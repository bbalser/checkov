defmodule Checkov do

  defmacro __using__(_opts) do
    quote do
      import Checkov
      use ExUnit.Case
    end
  end

  defmacro data_test(name, context \\ quote(do: %{}), do: do_block) do
    {test_block, where} = Macro.prewalk(do_block, {}, fn exp, acc ->
      case match?({:where, _, _}, exp) do
        true -> {nil, exp}
        false -> {exp, acc}
      end
    end)

    get_bindings(where)
    |> Enum.map(fn binding -> { unrolled_name(name, binding), binding } end)
    |> Enum.reduce([], fn {name, binding}, acc -> [ {name, fix_name(name, acc), binding} | acc] end)
    |> Enum.map(fn {_original_name, name, binding} ->
      create_test(name, binding, test_block, context)
    end)
  end

  defp fix_name(name, test_defs) do
    count = Enum.count(test_defs, fn {original_name, fixed_name, _binding} -> original_name == name end)
    case count == 0 do
      true -> name
      false -> name <> " - #{count+1}"
    end
  end

  defp unrolled_name(name, binding) do
    name_block = Macro.postwalk(name, fn exp ->
      case is_binding_variable?(exp, binding) do
        true -> {:var!, [context: Elixir, import: Kernel], [exp]}
        false -> exp
      end
    end)

    {unrolled_name, _ } = Code.eval_quoted(name_block, binding)
    unrolled_name
  end

  defp is_binding_variable?({atom, _, nil}, binding) do
    Keyword.has_key?(binding, atom)
  end
  defp is_binding_variable?(_exp, _binding), do: false

  defp create_test(name, binding, test_block, context) do
    quoted_variables = Enum.map(binding, fn { variable_name, variable_value} ->
      {:=, [], [{:var!, [context: Elixir, import: Kernel], [{variable_name, [], Elixir}]}, variable_value]}
    end)

    quote do
      test unquote(name), unquote(context) do
        unquote_splicing(quoted_variables)
        unquote(test_block)
      end
    end
  end

  defp get_bindings({:where, _, [[{key,data}|_tail] = keywords]}) when is_atom(key) do
    0..(Enum.count(data)-1)
    |> Enum.map(fn index -> create_binding(keywords, index) end)
  end
  defp get_bindings({:where, _ , [[variables|data]]}) do
    Enum.map(data, fn list -> Enum.zip(variables, list) end)
  end

  defp create_binding(keywords, index) do
    Keyword.keys(keywords)
    |> Enum.map(fn key ->
      { key, Keyword.get(keywords, key) |> Enum.at(index) }
    end)
  end

end
