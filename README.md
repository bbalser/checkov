# Checkov

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



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `checkov` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:checkov, "~> 0.2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/checkov](https://hexdocs.pm/checkov).

