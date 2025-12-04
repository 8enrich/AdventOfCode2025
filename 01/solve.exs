import Enum
import String
import Integer

defmodule Day01 do

  def get_parsed_input(filename) do
    File.read(filename)
    |> elem(1)
    |> trim()
    |> split()
    |> map(fn x -> split_at(x, 1) end)
    |> map(
      fn x -> 
        case x do
          {"L", a} -> 
            -1 * elem(parse(a), 0)
          {"R", a} ->
            1 * elem(parse(a), 0)
        end
      end
    )
  end

  def solve_01() do
    Day01.get_parsed_input("./input.txt")
    |> scan(50, fn x, acc -> rem(rem(x, 100) + acc + 100, 100) end)
    |> count(fn x -> x == 0 end)
  end

  def solve_02() do
    Day01.get_parsed_input("./input.txt")
    |> reduce(
      {0, 50}, fn direction, { clicks, dial } -> 
        next_dial = rem(rem(direction, 100) + dial + 100, 100)
        cond do
          next_dial == 0 ->
            { clicks + 1 + div(abs(direction), 100), next_dial }
          direction < 0 and next_dial > dial and dial != 0 ->    
            { clicks + 1 + div(abs(direction), 100), next_dial }
          direction > 0 and next_dial < dial ->
            { clicks + 1 + div(abs(direction), 100), next_dial }
          true ->
            { clicks + div(abs(direction), 100), next_dial }
        end
      end
    )
    |> elem(0)
  end 
end

IO.puts("01:\n" <> Integer.to_string(Day01.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day01.solve_02()))
