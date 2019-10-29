defmodule ExceptionTest do
  use ExUnit.Case
  import CompileTimeAssertions

  test "compilation should fail with proper exception when all binding lengths are not the same" do
    assert_compile_time_raise Checkov.InvalidBindingsException,
                              "All bindings in where function must be the same length" do
      defmodule Fake1Test do
        use Checkov

        data_test "fake 1" do
          assert a == b

          where([
            [:a, :b],
            [1, 2],
            [3, 4, 5]
          ])
        end
      end
    end
  end

  test "compilate should fail when all keywords are not the same length" do
    assert_compile_time_raise Checkov.InvalidBindingsException,
                              "All bindings in where function must be the same length" do
      defmodule Fake2Test do
        use Checkov

        data_test "fake 2" do
          assert a == b

          where(
            a: [1, 2, 3, 4],
            b: [1, 2, 3]
          )
        end
      end
    end
  end
end
