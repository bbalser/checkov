defmodule Checkov.Binding do

  def get_bindings({:where, _, [[{key,data}|_tail] = keywords]}) when is_atom(key) do
    0..(Enum.count(data)-1)
    |> Enum.map(fn index -> create_binding(keywords, index) end)
  end
  def get_bindings({:where, _ , [[variables|data]]}) do
    Enum.map(data, fn list -> Enum.zip(variables, list) end)
  end

  defp create_binding(keywords, index) do
    Keyword.keys(keywords)
    |> Enum.map(fn key ->
      { key, Keyword.get(keywords, key) |> Enum.at(index) }
    end)
  end

  def valid?({:where, _, [[{key,_data}|_tail] = keywords]}) when is_atom(key) do
    Keyword.values(keywords) |> all_same_count?()
  end
  def valid?({:where, _, [list]}) do
    all_same_count?(list)
  end

  defp all_same_count?([head|tail]) do
    Enum.all?(tail, fn sublist -> Enum.count(sublist) == Enum.count(head) end)
  end

end
