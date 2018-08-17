defmodule CheckovTest do
  use Checkov

  data_test "#{a} + #{b} == #{result}" do
    assert a + b == result

    where [
      [:a, :b, :result],
      [1, 2, 3],
      [4, 5, 9],
      [1.2, 3.4, 4.6],
      [2, -3, -1],
      [2, 4, 2*3]
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

  data_test "equality: #{x} == #{y}" do
    assert x == y

    where x: [1,2,3,4, 2*3],
          y: [1,2,3,4, 6]
  end

  data_test "something" do
    assert x == y

    where x: [1, 2, 4, -1],
          y: [1, 2, 4, -1]
  end

  defp stuff(x), do: x + 1

end
