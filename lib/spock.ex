defmodule Spock do

  defmacro __using__(_opts) do
    quote do
      import Spock
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

    {variables, data} = separate_data(where)

    Enum.map(data, fn values ->
      create_test(name, variables, values, test_block, context)
    end)
  end

  defp create_test(name, variables, data, test_block, context) do
    binding = Enum.zip(variables, data)
    {unrolled_name, _ } = Code.eval_quoted(name, binding)

    quoted_variables = Enum.map(binding, fn { var, value} ->
      {:=, [], [{:var!, [context: Elixir, import: Kernel], [{var, [], Elixir}]}, value]}
    end)

    quote do
      test unquote(unrolled_name), unquote(context) do
        unquote_splicing(quoted_variables)
        unquote(test_block)
      end
    end
  end


  defp separate_data({:where, _, [[head|tail]]}) do
    {head, tail}
  end

end
