defmodule SpockTest do
  use Spock

  data_test "#{a} + #{b} == #{result}" do
    assert a + b == result

    where [
      [:a, :b, :result],
      [1, 2, 3],
      [4, 5, 9],
      [1.2, 3.4, 4.6]
    ]
  end

  data_test "stuff(#{x}) == #{expected}" do
    result = stuff(x)
    assert expected == result

    where [
      [:x, :expected],
      [1, 2],
      [100, 101]
    ]
  end

  defp stuff(x), do: x + 1

end
