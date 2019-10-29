ExUnit.start(trace: true)

defmodule CompileTimeAssertions do
  defmodule(DidNotRaise, do: defstruct(message: nil))

  defmacro assert_compile_time_raise(expected_exception, expected_message, do: do_block) do
    actual_exception =
      try do
        Code.eval_quoted(do_block)
        %DidNotRaise{}
      rescue
        e -> e
      end

    quote do
      assert unquote(actual_exception.__struct__) === unquote(expected_exception)
      assert unquote(actual_exception.message) === unquote(expected_message)
    end
  end
end

defmodule FakeSetup do
  def y_values(), do: [1, 2, 3]
end
