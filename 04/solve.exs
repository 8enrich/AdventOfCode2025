import Enum
import String

defmodule Day04 do

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
  end

  def solve_01() do
    Day04.get_parsed_input("./input.txt")
    |> get_papers_to_remove()
    |> count()
  end

  def solve_02() do
    Day04.get_parsed_input("./input.txt")
    |> iterate_and_remove()
  end

  def get_papers_to_remove(indexes_map) do
    iterate(indexes_map)
    |> filter(fn { _, analyze } -> analyze != [] end)
    |> map(fn { cord, analyze } -> {cord ,count(analyze, fn y -> y == true end)} end)
    |> filter(fn { _, analyze } -> analyze < 4 end)
  end

  def iterate(indexes_map) do
    size = round(:math.sqrt(map_size(indexes_map))) - 1
    flat_map(0..size, fn i -> map(0..size, fn j -> {{i, j}, analyze_map_item(indexes_map, i, j)} end) end)
  end

  def analyze_map_item(indexes_map, i, j) do
    char = Map.get(indexes_map, {i, j})
    analyze_char(char, indexes_map, i, j)
  end

  def analyze_char(char, indexes_map, i, j) when char == "@", do: analyze_adjacent(indexes_map, i, j)

  def analyze_char(_, _, _, _), do: []

  def analyze_adjacent(indexes_map, i, j) do
    flat_map(-1..1, fn x -> 
      map(-1..1, fn y -> is_roll_of_paper(Map.get(indexes_map, {i + x, j + y}), x, y) end) 
    end)
  end

  def is_roll_of_paper(_, x, y) when x == 0 and y == 0, do: false

  def is_roll_of_paper(char, _, _), do: char == "@"

  def iterate_and_remove(indexes_map, paper_to_remove \\ 0) do
    analyzed_list = get_papers_to_remove(indexes_map)
    count_paper_to_remove = count(analyzed_list)
    new_analyzed_list = reduce(analyzed_list, indexes_map, fn { cord, _ }, acc ->
      Map.replace(acc, cord, ".") end)
    reiterate_and_remove(new_analyzed_list, count_paper_to_remove, paper_to_remove)
  end 

  def reiterate_and_remove(_, count_paper_to_remove, paper_to_remove) when count_paper_to_remove == 0 do 
    paper_to_remove
  end

  def reiterate_and_remove(analyzed_list, count_paper_to_remove, paper_to_remove) do
    iterate_and_remove(analyzed_list, count_paper_to_remove + paper_to_remove)
  end
end

IO.inspect(Day04.solve_01(), label: "01")

IO.inspect(Day04.solve_02(), label: "02")
