defmodule Checkov do
  @moduledoc """

  Checkov aims to emulate the data driven testing functionality of the [Spock Framework](http://spockframework.org/)

  A where block can be used in a data_test to exercise the assertions of the test multiple times.

  ```
  defmodule MyModuleTest do
    use ExUnit.Case
    import Checkov

    data_test "\#{a} + \#{b} == \#{result}" do
      assert a + b == result

      where [
        [:a, :b, :result],
        [1, 2, 3],
        [4, 5, 9],
        [1.2, 3.4, 4.6],
      ]
    end

  end
  ```

  Will create and run three tests.

  ```
  MyModuleTest
  * test 4 + 5 == 9 (0.00ms)
  * test 1 + 2 == 3 (0.00ms)
  * test 1.2 + 3.4 == 4.6 (0.00ms)


  Finished in 0.03 seconds
  3 tests, 0 failures
  ```

  Checkov also support an alternative syntax, below will create and run the same three tests.

  ```
  defmodule MyModuleTest do
    use ExUnit.Case
    import Checkov

    data_test "\#{a} + \#{b} == \#{result}" do
      assert a + b == result

      where a:      [1, 4, 1.2],
            b:      [2, 5, 3.4],
            result: [3, 9, 4.6]

    end

  end

  ```

  Data tests also accept an optional second paramter where you can receive the context from a setup block.
  Any variable created in there where block is available to be used in the name of the test!

  """

  defmodule InvalidBindingsException do
    defexception [:message]
  end

  defmacro __using__(_opts) do
    quote do
      import Checkov
      use ExUnit.Case
    end
  end

  defmacro data_test(name, context \\ quote(do: %{}), do: do_block) do
    {test_block, where} = extract_where_function(do_block)

    if not Checkov.Binding.valid?(where) do
      raise InvalidBindingsException, message: "All bindings in where function must be the same length"
    end

    Checkov.Binding.get_bindings(where)
    |> Enum.map(fn binding -> { Checkov.TestName.unroll_name(name, binding), binding } end)
    |> Enum.reduce([], fn {name, binding}, acc -> [ {name, fix_name(name, acc), binding} | acc] end)
    |> Enum.map(fn {_original_name, name, binding} ->
      create_test(name, binding, test_block, context)
    end)
  end

  defp extract_where_function(body) do
    Macro.prewalk(body, {}, fn exp, acc ->
      case match?({:where, _, _}, exp) do
        true -> {nil, exp}
        false -> {exp, acc}
      end
    end)
  end

  defp fix_name(name, test_defs) do
    count = Enum.count(test_defs, fn {original_name, _fixed_name, _binding} -> original_name == name end)
    case count == 0 do
      true -> name
      false -> name <> " [#{count+1}]"
    end
  end

  defp create_test(name, binding, test_block, context) do
    quoted_variables = Enum.map(binding, fn { variable_name, variable_value} ->
      {:=, [], [{:var!, [context: Elixir, import: Kernel], [{variable_name, [], Elixir}]}, variable_value]}
    end)

    quote do
      test unquote(name), unquote(context) do
        unquote_splicing(quoted_variables)
        unquote(test_block)
      end
    end
  end


end
