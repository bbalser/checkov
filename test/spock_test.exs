defmodule SpockTest do
  use Spock

  data_test "#{var!(a)} + #{var!(b)} == #{var!(result)}" do
    assert a + b == result

    where [
      [:a, :b, :result],
      [1, 2, 3],
      [4, 5, 9],
      [1.2, 3.4, 4.6]
    ]
  end

end
