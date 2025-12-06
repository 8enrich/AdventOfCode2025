import Enum

defmodule Day06 do

  def get_parsed_input_01(filename) do
    File.read(filename)
    |> elem(1)
    |> String.trim()
    |> String.split("\n")
    |> map(fn x -> String.split(x) end) 
    |> zip()
    |> map(fn x -> Tuple.to_list(x) end)
    |> map(fn x -> reverse(x) end)
    |> map(fn x -> 
      { hd(x), map(tl(x), fn y -> elem(Integer.parse(y), 0) end) }
    end)
  end

  def get_parsed_input_02(filename) do
    File.read(filename)
    |> elem(1)
    |> String.split("\n")
    |> map(fn x -> String.graphemes(x) end)
    |> drop(-1)
    |> split(-1)
    |> separete_operation_and_values()
    |> zip()
    |> map(fn { operation, values } -> 
      { operation, map(values, fn x -> String.trim(List.to_string(x))  end)} 
    end)
    |> map(fn { operation, values } -> 
      { operation, map(values, fn x -> elem(Integer.parse(x), 0)  end)} 
    end)
  end

  def solve_01() do
    Day06.get_parsed_input_01("./input.txt")
    |> map(fn { operation, values } -> make_operation(operation, values) end)
    |> sum()
  end

  def solve_02() do
    Day06.get_parsed_input_02("./input.txt")
    |> map(fn { operation, values } -> make_operation(operation, values) end)
    |> sum()
  end

  def make_operation(operation, values) when operation == "*", do: product(values)

  def make_operation(operation, values) when operation == "+", do: sum(values)

  def separete_operation_and_values(operation_and_values) do
    { values, operation } = operation_and_values
    parsed_values = values |> zip() |> map(fn x -> Tuple.to_list(x) end) |> remove_empty()
    [ filter(hd(operation), fn x -> x != " " end), parsed_values ]
  end

  def remove_empty(list) do
    chunk_fun = fn element, acc ->
      cond do
        count(filter(element, fn x -> x != " " end)) == 0 ->
          {:cont, acc, []}
        true ->
          {:cont, [ element | acc ]}
      end
    end
    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, reverse(acc), []}
    end
    chunk_while(list, [], chunk_fun, after_fun)
  end
end

IO.puts("01:\n" <> Integer.to_string(Day06.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day06.solve_02()))
