defmodule MarketData do
  @moduledoc """
    Functions for processing a large file containing stock market data.
  """

  def main do
    [properties | data] = read_data_as_text_from_file("res/data.txt")
    objects = create_objects_as_maps(data, properties, [])
    retrieve_top_currencies_by_property(objects, "changePercent", 3)
  end

  def read_data_as_text_from_file(path) do
    read_lines_from_file(path)
  end

  def read_lines_from_file(path) do
    lines =
      path
      |> File.stream!()
      |> Enum.map(&String.trim/1)

    lines |> Enum.map(&split_line_into_tokens(&1))
  end

  def parse_string(string) do
    possible_integer = Integer.parse(string)
    if is_tuple(possible_integer) and elem(possible_integer, 1) == "", do: elem(possible_integer, 0)
    possible_float = Float.parse(string)
    if is_tuple(possible_float) and elem(possible_float, 1) == "", do: elem(possible_float, 0), else: string
  end

  def split_line_into_tokens(line) do
    Regex.split(~r/\s+/, line)
  end

  def create_objects_as_maps([], _, objects), do: objects
  def create_objects_as_maps([list | lists], properties, objects) do
    object = Enum.zip(0..length(properties), list)
      |> Enum.map(fn {index, value} -> {Enum.at(properties, index), parse_string(value)} end)
      |> Enum.into(%{})
    create_objects_as_maps(lists, properties, [object | objects])
  end

  def retrieve_top_currencies_by_property(objects, property, number_of_currencies) do
    objects
    |> Enum.sort(fn x, y -> x[property] > y[property] end)
    |> Enum.take(number_of_currencies)
  end
end
