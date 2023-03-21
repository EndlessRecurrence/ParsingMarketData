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
end
