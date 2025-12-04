import Enum
import Integer

defmodule Day03 do

  def get_parsed_input(filename) do
    File.read(filename)
    |> elem(1)
    |> String.trim()
    |> String.split()
    |> map(fn x -> String.graphemes(x) end)
  end

  def solve_01() do
    Day03.get_parsed_input("./input.txt")
    |> map(fn x -> get_maximum_voltage(x, 2) end) 
    |> map(fn x -> elem(parse(x), 0) end)
    |> sum()
  end

  def solve_02() do
    Day03.get_parsed_input("./input.txt")
    |> map(fn x -> get_maximum_voltage(x, 12) end) 
    |> map(fn x -> elem(parse(x), 0) end)
    |> sum()
  end

  def get_maximum_voltage(number, n), do: get_maximum_voltage_n(number, n, [])

  def get_maximum_voltage_n(_, n, voltage) when length(voltage) == n, do: List.to_string(voltage)

  def get_maximum_voltage_n(number, n, voltage) do
    { first, last } = split(number, -(n - 1 - length(voltage)))
    value = get_max_of_first_and_last(first, last)
    index = Enum.find_index(number, fn x -> x == value end)
    get_maximum_voltage_n(drop(number, index + 1), n, voltage ++ [value])
  end

  def get_max_of_first_and_last([], last), do: max(last)

  def get_max_of_first_and_last(first, _), do: max(first)
end

IO.puts("01:\n" <> Integer.to_string(Day03.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day03.solve_02()))
