import Enum
import String

defmodule Day08 do

  def get_parsed_input(filename) do
    File.read(filename)
    |> elem(1)
    |> trim()
    |> split()
    |> map(fn x -> String.split(x, ",") end)
    |> map(fn x ->
      List.to_tuple(map(x, fn y -> elem(Integer.parse(y), 0) end))
    end)
  end

  def solve_01() do
    Day08.get_parsed_input("./input.txt")
    |> get_distances()
    |> sort_by(fn x -> elem(x, 2) end)
    |> take(1000)
    |> map(fn { j1, j2, _} -> {j1, j2} end)
    |> map(fn x -> Tuple.to_list(x) end)
    |> map(fn x -> MapSet.new(x) end)
    |> reduce([], fn x, acc -> make_connection(acc, x) end)
    |> map(fn x -> MapSet.to_list(x) end)
    |> sort_by(fn x -> Kernel.length(x) end, :desc)
    |> take(3)
    |> map(fn x -> Kernel.length(x) end)
    |> product()
  end

  def solve_02() do
    input = Day08.get_parsed_input("./input.txt")
    len = Kernel.length(input)
    input
    |> get_distances()
    |> sort_by(fn x -> elem(x, 2) end)
    |> map(fn { j1, j2, _} -> {j1, j2} end)
    |> map(fn x -> Tuple.to_list(x) end)
    |> map(fn x -> MapSet.new(x) end)
    |> make_connections_until_has_one_circuit(len)
    |> List.last()
    |> MapSet.to_list()
    |> map(fn { x, _, _ } -> x end)
    |> product()
  end

  def get_distances([]), do: []

  def get_distances(points) do
    [ head | tail ] = points
    get_distances(head, tail) ++ get_distances(tail)
  end

  def get_distances(_, []), do: []

  def get_distances(point, points) do
    [ head | tail ] = points
    [ { point, head, straight_line_distance(point, head) } ] ++ get_distances(point, tail)
  end

  def straight_line_distance({ x1, y1, z1 }, { x2, y2, z2 }) do
    :math.sqrt((x1 - x2)**2 + (y1 - y2)**2 + (z1 - z2)**2)
  end

  def make_connection(circuits, junction) do
    elements = filter(circuits, fn x -> not(MapSet.disjoint?(junction, x)) end)
    make_connection(circuits, junction, elements)
  end
  
  def make_connection(circuits, junction, []), do: circuits ++ [ junction ]

  def make_connection(circuits, junction, elements) do
    new_circuits = reduce(elements, circuits, fn x, acc -> List.delete(acc, x) end)
    new_set = reduce(elements, MapSet.new(), fn x, acc -> MapSet.union(acc, x) end)
    new_circuits ++ [ MapSet.union(new_set, junction) ]
  end

  def make_connections_until_has_one_circuit(circuits, len), do: make_connections_until_has_one_circuit(circuits, len, [], [])

  def make_connections_until_has_one_circuit(circuits, len, list, connect_order) do
    [ head | tail ] = circuits
    list = make_connection(list, head)
    cond do
      len == MapSet.size(List.first(list)) ->
        connect_order ++ [ head ]
      true ->
        list = make_connections_until_has_one_circuit(tail, len, list, connect_order ++ [ head ])
        list
    end
  end
end

IO.puts("01:\n" <> Integer.to_string(Day08.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day08.solve_02()))
