defmodule MarketData do
  @moduledoc """
    Functions for processing a large file containing stock market data.
  """

  def convert_file_data_into_objects do
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
    if is_tuple(Integer.parse(string)) and elem(Integer.parse(string), 1) == "" do
      elem(Integer.parse(string), 0)
    else
      if is_tuple(Float.parse(string)) and elem(Float.parse(string), 1) == "", do: elem(Float.parse(string), 0), else: string
    end
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
