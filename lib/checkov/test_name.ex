defmodule Checkov.TestName do
  def unroll_name(name, binding) do
    {processed_name, used_bindings} = process_name(name, binding)
    evaluated_binding = evaluate_binding(used_bindings)

    {unrolled_name, _} = Code.eval_quoted(processed_name, evaluated_binding)
    unrolled_name
  end

  defp evaluate_binding(binding) do
    Enum.map(binding, fn {key, quoted_exp} ->
      {value, _} = Code.eval_quoted(quoted_exp)
      {key, value}
    end)
  end

  defp process_name(name, binding) do
    Macro.postwalk(name, [], fn exp, acc ->
      case binding_variable(exp, binding) do
        nil -> {exp, acc}
        binding -> {{:var!, [context: Elixir, import: Kernel], [exp]}, [binding | acc]}
      end
    end)
  end

  defp binding_variable({atom, _, nil}, binding) do
    case Keyword.has_key?(binding, atom) do
      true -> {atom, Keyword.get(binding, atom)}
      false -> nil
    end
  end

  defp binding_variable(_exp, _binding), do: nil
end
