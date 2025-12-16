import Enum
import String

defmodule Day09 do

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
    Day09.get_parsed_input("./input.txt")
    |> get_distances()
    |> map(fn x -> elem(x, 2) end)
    |> max()
  end

  def solve_02() do
    Day09.get_parsed_input("./input.txt")
    |> get_edges_and_input()
    |> verify_squares()
  end

  def get_distances([]), do: []

  def get_distances(points) do
    [ head | tail ] = points
    get_distances(head, tail) ++ get_distances(tail)
  end

  def get_distances(_, []), do: []

  def get_distances(point, points) do
    [ head | tail ] = points
    [ { point, head, get_area(point, head) } ] ++ get_distances(point, tail)
  end

  def get_area({ x1, y1 }, { x2, y2 }) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def get_edges_and_input(input) do
    { 
      get_edges_from_points(input),
      input |> get_distances() |> sort_by(fn x -> elem(x, 2) end, :desc), 
    }
  end

  def get_edges_from_points(edges) do
    edges ++ [ hd(edges) ] |> chunk_every(2, 1, :discard)
  end

  def verify_squares({ edges, distances }) do
    [ head | tail ] = distances
    cond do
      is_cords_inside(Tuple.delete_at(head, 2), edges) ->
        elem(head, 2)
      true ->
        verify_squares({ edges, tail })
    end
  end

  def is_cords_inside(cords, edges) do
    { { x1, y1 }, { x2, y2 } } = cords
    rectangle_points = [ 
      { Kernel.min(x1, x2) + 0.5, Kernel.min(y1, y2) + 0.5 },
      { Kernel.min(x1, x2) + 0.5, Kernel.max(y1, y2) - 0.5 },
      { Kernel.max(x1, x2) - 0.5, Kernel.max(y1, y2) - 0.5 },
      { Kernel.max(x1, x2) - 0.5, Kernel.min(y1, y2) + 0.5 }
    ]
    rectangle_edges = get_edges_from_points(rectangle_points)
    not(has_collision(edges, rectangle_edges))
  end

  def has_collision(_, []), do: false

  def has_collision(edges, rectangle_edges) do
    [ [ { xa, ya }, { xb, yb } ] | tail ] = rectangle_edges
    any?(edges, fn [ { x1, y1 }, { x2, y2 } ] -> 
      (
        Kernel.min(xa, xb) <= x1
        && Kernel.max(xa, xb) >= x2
        && ya >= Kernel.min(y1, y2)
        && yb <= Kernel.max(y1, y2)
      ) 
      ||
      (
        xa >= Kernel.min(x1, x2) 
        && xb <= Kernel.max(x1, x2)
        && Kernel.min(ya, yb) <= y1
        && Kernel.max(ya, yb) >= y2
      )
    end) || has_collision(edges, tail)
  end
end

IO.inspect(Day09.solve_01(), label: "01")

IO.inspect(Day09.solve_02(), label: "02")
