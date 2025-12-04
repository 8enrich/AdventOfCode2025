import Enum

defmodule Day02 do

  def get_parsed_input(filename) do
    File.read(filename)
    |> elem(1)
    |> String.trim()
    |> String.split(",")
    |> map(fn x -> 
        String.split(x, "-") 
      end
    )
  end

  def solve_01() do
    Day02.get_parsed_input("./input.txt")
    |> flat_map(fn [ first | last ] -> 
        check_invalid_ids(first, hd(last))
      end
    )
    |> MapSet.new()
    |> sum()
  end

  def solve_02() do
    Day02.get_parsed_input("./input.txt")
    |> flat_map(fn [ first | last ] -> 
        check_invalid_ids_sequencial(first, hd(last))
      end
    )
    |> MapSet.new()
    |> sum()
  end

  def check_invalid_ids(first, last) do
    len = String.length(first)
    begin = String.slice(first, 0, div(len + 1, 2))
    end_n = String.slice(first, div(len + 1, 2), len)
    first_int = elem(Integer.parse(first), 0)
    cond do
      first_int > elem(Integer.parse(last), 0) ->
        [0]
      begin == end_n ->
        [elem(Integer.parse(first), 0)] ++ check_invalid_ids(Integer.to_string(first_int + 1), last)
      rem(len, 2) != 0 ->
        check_invalid_ids(Integer.to_string(10 ** len), last)
      true ->
        check_invalid_ids(Integer.to_string(first_int + 1), last)
    end
  end

  def check_invalid_ids_sequencial(first, last) do
    first_int = elem(Integer.parse(first), 0)
    cond do
      first_int > elem(Integer.parse(last), 0) ->
        [0]
      verify_valid_number(first, 1, 1) ->
        [elem(Integer.parse(first), 0)] ++ check_invalid_ids_sequencial(Integer.to_string(first_int + 1), last)
      true ->
        check_invalid_ids_sequencial(Integer.to_string(first_int + 1), last)
    end 
  end

  def verify_valid_number(number, index, window_size) do
    len = String.length(number)
    verify_valid_number(number, index, window_size, len)
  end

  def verify_valid_number(_, _, window_size, len) when window_size == len, do: false

  def verify_valid_number(_, index, _, len) when index >= len, do: true

  def verify_valid_number(number, index, window_size, _) do
    cond do  
      String.slice(number, 0, window_size) == String.slice(number, index, window_size) ->
        true and verify_valid_number(number, index + window_size, window_size)
      true ->
        move_window_or_index(number, index, window_size)
    end
  end

  def move_window_or_index(number, index, window_size) when index < window_size + 1, do: true and verify_valid_number(number, index + 1, window_size + 1)

  def move_window_or_index(number, index, window_size), do: true and verify_valid_number(number, index, window_size + 1)
end

IO.puts("01:\n" <> Integer.to_string(Day02.solve_01()))

IO.puts("02:\n" <> Integer.to_string(Day02.solve_02()))
