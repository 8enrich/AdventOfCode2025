import Enum
import List

defmodule Day05 do

  def get_parsed_input(filename) do
    File.read(filename)
    |> elem(1)
    |> String.split("\n\n")
    |> map(fn x -> String.split(x) end)
    |> parse_intervals()
  end

  def solve_01() do
    Day05.get_parsed_input("./input.txt")
    |> verify_contains()
    |> filter(fn x -> x == true end)
    |> count()
  end

  def solve_02() do
    Day05.get_parsed_input("./input.txt")
    |> elem(0)
    |> sort()
    |> reduce([], fn x, acc -> merge_intervals(acc, x) end)
    |> map(fn x -> Range.size(x) end)
    |> sum()
  end

  def parse_intervals(intervals_and_values) do
    [ intervals | values ] = intervals_and_values
    { map(intervals, fn x -> 
        numbers = String.split(x, "-") 
        elem(Integer.parse(hd(numbers)), 0)..elem(Integer.parse(last(numbers)), 0)
      end), map(hd(values), fn x -> elem(Integer.parse(x), 0) end)
    }
  end

  def verify_contains(intervals_and_values) do
    { intervals, values } = intervals_and_values
    map(values, fn x -> any?(intervals, fn y -> member?(y, x) end) end)
  end

  def merge_intervals(acc, x) when acc == [], do: [ x ]

  def merge_intervals(acc, x) do
    cond do
      not(Range.disjoint?(x, last(acc))) -> 
        drop(acc, -1)
          ++ [ Kernel.min(x.first, last(acc).first)..Kernel.max(x.last, last(acc).last) ]
      true ->
        acc ++ [ x ]
    end
  end
end

IO.inspect(Day05.solve_01(), label: "01")

IO.inspect(Day05.solve_02(), label: "02")
