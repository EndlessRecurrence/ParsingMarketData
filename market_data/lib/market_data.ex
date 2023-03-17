defmodule MarketData do
  @moduledoc """
    Functions for processing a large file containing stock market data.
  """

  def main do
    read_data_as_text_from_file("res/data.txt")
  end

  def read_data_as_text_from_file(path) do
    read_lines_from_file(path)
      |> create_map_of_properties()
  end

  def read_lines_from_file(path) do
    lines =
      path
      |> File.stream!()
      |> Enum.map(&String.trim/1)

    lines |> Enum.map(&split_line_into_tokens(&1))
  end

  def split_line_into_tokens(line) do
    Regex.split(~r/\s+/, line)
  end

  def create_map_of_properties(split_lines) do
    properties = split_lines
      |> Enum.at(0)
      |> Enum.map(&String.to_atom(&1))

    [_ | rest_of_the_lines] = split_lines
    map = Enum.reduce(properties, %{}, fn x, acc ->
      Map.put(acc, x, [])
    end)

    add_values_to_map(rest_of_the_lines, properties, map)
  end

  def add_values_to_map([], _, map), do: map
  def add_values_to_map([line | lines], properties, map) do
    row_as_map =
      Enum.zip(0..length(line), line)
      |> Enum.map(fn {index, value} -> {Enum.at(properties, index), value} end)
      |> Keyword.new()
      |> Enum.into(%{})

    map = Map.merge(map, row_as_map, fn key, v1, v2 ->
      [v2 | v1]
    end)
    add_values_to_map(lines, properties, map)
  end
end
