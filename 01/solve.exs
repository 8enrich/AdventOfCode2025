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
    Day01.get_parsed_input("./example.txt")
    |> reduce(
      {0, 50}, fn x, { clicks, dial } -> 
        rotate(clicks, dial, x)
      end
    )
    |> elem(0)
  end
  
  def rotate(clicks, dial, direction) do
    cond do
      direction == 0 ->
        { clicks, dial }
      direction < 0 ->
        { next_clicks, next_dial } = rotate(clicks, rem(dial - 1 + 100, 100), direction + 1) 
        cond do
          next_dial == 0 ->
            { clicks + next_clicks, next_dial }
        end
        { clicks + next_clicks, next_dial }
      direction > 0 ->
        { next_clicks, next_dial } = rotate(clicks, rem(dial + 1 + 100, 100), direction - 1) 
        { clicks + next_clicks, next_dial }
    end
  end
end

IO.puts("01:\n" <> Integer.to_string(Day01.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day01.solve_02()))
