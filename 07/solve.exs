import Enum
import String

defmodule Day07 do

  def get_parsed_input(filename) do
    File.read(filename)
    |> elem(1)
    |> trim()
    |> split()
    |> map(fn x -> with_index(graphemes(x)) end)
    |> with_index()
    |> reduce(%{}, fn { values, index_row }, acc -> 
        reduce(values, acc, fn { char, index_col}, acc -> 
          Map.put(acc, {index_row, index_col}, char) end) end)
    |> get_cord_of_S_and_map()
  end

  def solve_01() do
    Day07.get_parsed_input("./input.txt")
    |> get_splitter_paths()
    |> count()
  end

  def solve_02() do
    Day07.get_parsed_input("./input.txt")
    |> get_splitter_paths()
    |> max_by(fn { _, value } -> value end)
    |> elem(1)
  end

  def get_cord_of_S_and_map(map) do
    { Map.to_list(map) |> List.keyfind("S", 1) |> elem(0), map }
  end

  def get_splitter_paths(cord_and_map) do
    { _, map } = cord_and_map
    paths = get_paths(cord_and_map)
    splitter_cords = Map.to_list(map) |> filter(fn { _, char } -> char == "^" end) |> map(fn x -> elem(x, 0) end) |> MapSet.new()
    Map.to_list(paths) |> filter(fn { { x, y }, _ } -> MapSet.member?(splitter_cords, { x + 1, y }) end)
  end

  def get_paths(cord_and_map, cord_paths \\ Map.new()) do
    { { x, y }, map } = cord_and_map
    next_cord = { x + 1, y }
    next_char = Map.get(map, next_cord)
    cond do
      next_char == nil ->
        Map.put(cord_paths, { x, y }, 1) 
      Map.has_key?(cord_paths, { x, y }) ->
        cord_paths
      next_char == "." ->
        new_cord_paths = get_paths({ next_cord, map }, cord_paths)
        Map.put(new_cord_paths, { x, y }, Map.get(new_cord_paths, next_cord))
      true -> 
        left_cord_paths = get_paths({ { x + 1, y + 1 }, map }, cord_paths)
        right_cord_paths = get_paths({ { x + 1, y - 1}, map }, left_cord_paths)
        Map.put(right_cord_paths, { x, y }, Map.get(right_cord_paths, { x + 1, y + 1 }) + Map.get(right_cord_paths, { x + 1, y - 1 }))
    end
  end
end

IO.puts("01:\n" <> Integer.to_string(Day07.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day07.solve_02()))
