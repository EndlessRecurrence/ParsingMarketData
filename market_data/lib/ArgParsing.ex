defmodule ArgParsing do
  def process_arguments(args) do
    process_arguments(args, [], [])
  end
  defp process_arguments([], incorrect_tokens, correct_tokens), do: {incorrect_tokens, correct_tokens}
  defp process_arguments([arg | args], incorrect_tokens, correct_tokens) do
    status = Regex.match?(~r/^--[a-zA-Z]+=.+$/, arg)
    if status == false do
      process_arguments(args, [arg | incorrect_tokens], correct_tokens)
    else
      arg_without_dashes = Regex.replace(~r/--/, arg, "", global: true)
      key_value_pair_as_list = Regex.split(~r/=/, arg_without_dashes)

      process_arguments(args, incorrect_tokens, [key_value_pair_as_list | correct_tokens])
    end
  end

  def are_arguments_allowed?(_, []), do: true
  def are_arguments_allowed?(allowed_arguments, [arg | args]) do
    Enum.member?(allowed_arguments, Enum.at(arg, 0)) && are_arguments_allowed?(allowed_arguments, args)
  end

  def get_argument_value_by_name([], name), do: :error
  def get_argument_value_by_name([arg | args], name) do
    if Enum.at(arg, 0) == name, do: Enum.at(arg, 1), else: get_argument_value_by_name(args, name)
  end

  def parse_string(string) when is_bitstring(string) do
    if is_tuple(Integer.parse(string)) and elem(Integer.parse(string), 1) == "" do
      elem(Integer.parse(string), 0)
    else
      if is_tuple(Float.parse(string)) and elem(Float.parse(string), 1) == "", do: elem(Float.parse(string), 0), else: string
    end
  end
  def parse_string(_), do: raise ArgumentError, message: "The input to parse_string should be a BitString."
end
