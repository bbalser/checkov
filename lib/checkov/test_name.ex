defmodule Checkov.TestName do

  def unroll_name(name, binding) do
    processed_name = process_name(name, binding)
    evaluated_binding = evaluate_binding(binding)

    {unrolled_name, _ } = Code.eval_quoted(processed_name, evaluated_binding)
    unrolled_name
  end

  defp evaluate_binding(binding) do
    Enum.map(binding, fn {key,quoted_exp} ->
      {value, _} = Code.eval_quoted(quoted_exp)
      {key, value}
    end)
  end

  defp process_name(name, binding) do
    Macro.postwalk(name, fn exp ->
      case is_binding_variable?(exp, binding) do
        true -> {:var!, [context: Elixir, import: Kernel], [exp]}
        false -> exp
      end
    end)
  end

  defp is_binding_variable?({atom, _, nil}, binding) do
    Keyword.has_key?(binding, atom)
  end
  defp is_binding_variable?(_exp, _binding), do: false

end
