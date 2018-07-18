defmodule MyModuleTest do
  use ExUnit.Case
  import Checkov

  data_test "#{a} + #{b} == #{result}" do
    assert a + b == result

    where a:      [1, 4, 1.2],
          b:      [2, 5, 3.4],
          result: [3, 9, 4.6]

    # where [
    #   [:a, :b, :result],
    #   [1, 2, 3],
    #   [4, 5, 9],
    #   [1.2, 3.4, 4.6],
    # ]
  end

end
