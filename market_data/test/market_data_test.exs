defmodule MarketDataTest do
  use ExUnit.Case
  doctest MarketData

  setup_all do
    {:ok, filepath: "res/data.txt", empty_filepath: "res/empty.txt"}
  end

  describe "required features:" do
    test "check if file data is converted into objects", state do
      assert MarketData.convert_file_data_into_objects(state[:filepath]) == [
        %{
          "changeAbsolute" => -0.0032,
          "changePercent" => -0.37,
          "currencyPair" => "EUR/GBP",
          "price" => 0.8604
        },
        %{
          "changeAbsolute" => -1.105,
          "changePercent" => -0.91,
          "currencyPair" => "EUR/JPY",
          "price" => 120.315
        },
        %{
          "changeAbsolute" => -0.005,
          "changePercent" => -0.07,
          "currencyPair" => "USD/CNY",
          "price" => 6.8599
        },
        %{
          "changeAbsolute" => 0.0007,
          "changePercent" => 0.07,
          "currencyPair" => "USD/CHF",
          "price" => 0.9927
        },
        %{
          "changeAbsolute" => 0.0092,
          "changePercent" => 0.71,
          "currencyPair" => "USD/CAD",
          "price" => 1.3112
        },
        %{
          "changeAbsolute" => -0.0032,
          "changePercent" => -0.42,
          "currencyPair" => "AUD/USD",
          "price" => 0.7648
        },
        %{
          "changeAbsolute" => -0.001,
          "changePercent" => -0.08,
          "currencyPair" => "GBP/USD",
          "price" => 1.2476
        },
        %{
          "changeAbsolute" => -0.494,
          "changePercent" => -0.44,
          "currencyPair" => "USD/JPY",
          "price" => 112.09
        },
        %{
          "changeAbsolute" => -0.0045,
          "changePercent" => -0.42,
          "currencyPair" => "EUR/USD",
          "price" => 1.0735
        }
      ]
    end

    test "check if the retrieval of the top 3 currencies works", state do
      assert MarketData.convert_file_data_into_objects(state[:filepath]) |>
      MarketData.retrieve_top_currencies_by_property("changePercent", 3) == [
        %{
          "changeAbsolute" => 0.0092,
          "changePercent" => 0.71,
          "currencyPair" => "USD/CAD",
          "price" => 1.3112
        },
        %{
          "changeAbsolute" => 0.0007,
          "changePercent" => 0.07,
          "currencyPair" => "USD/CHF",
          "price" => 0.9927
        },
        %{
          "changeAbsolute" => -0.005,
          "changePercent" => -0.07,
          "currencyPair" => "USD/CNY",
          "price" => 6.8599
        }
      ]
    end

    test "check if the retrieval of the top 5 currencies works", state do
      assert MarketData.convert_file_data_into_objects(state[:filepath]) |>
      MarketData.retrieve_top_currencies_by_property("changePercent", 5) == [
        %{
          "changeAbsolute" => 0.0092,
          "changePercent" => 0.71,
          "currencyPair" => "USD/CAD",
          "price" => 1.3112
        },
        %{
          "changeAbsolute" => 0.0007,
          "changePercent" => 0.07,
          "currencyPair" => "USD/CHF",
          "price" => 0.9927
        },
        %{
          "changeAbsolute" => -0.005,
          "changePercent" => -0.07,
          "currencyPair" => "USD/CNY",
          "price" => 6.8599
        },
        %{
          "changeAbsolute" => -0.001,
          "changePercent" => -0.08,
          "currencyPair" => "GBP/USD",
          "price" => 1.2476
        },
        %{
          "changeAbsolute" => -0.0032,
          "changePercent" => -0.37,
          "currencyPair" => "EUR/GBP",
          "price" => 0.8604
        }
      ]
    end
  end

  describe "file I/O operations and string processing:" do
    test "check if lines are read from the file properly", state do
      assert MarketData.read_data_as_text_from_file(state[:filepath]) == [
        ["currencyPair", "price", "changeAbsolute", "changePercent"],
        ["EUR/USD", "1.0735", "-0.0045", "-0.42"],
        ["USD/JPY", "112.0900", "-0.494", "-0.44"],
        ["GBP/USD", "1.2476", "-0.0010", "-0.08"],
        ["AUD/USD", "0.7648", "-0.0032", "-0.42"],
        ["USD/CAD", "1.3112", "0.0092", "0.71"],
        ["USD/CHF", "0.9927", "0.0007", "0.07"],
        ["USD/CNY", "6.8599", "-0.0050", "-0.07"],
        ["EUR/JPY", "120.3150", "-1.1050", "-0.91"],
        ["EUR/GBP", "0.8604", "-0.0032", "-0.37"]
      ]
    end

    test "check if string is properly tokenized with a single space as separator", _state do
      assert MarketData.split_line_into_tokens("a bbb c de") == ["a", "bbb", "c", "de"]
    end

    test "check if string is properly tokenized with multiple spaces as separators", _state do
      assert MarketData.split_line_into_tokens("a     bbb  c          de") == ["a", "bbb", "c", "de"]
    end

    test "check if string remains untokenized when there are no spaces in it", _state do
      assert MarketData.split_line_into_tokens("abbbcde") == ["abbbcde"]
    end
  end

  describe "data type conversions:" do
    test "check if strings representing integers are properly parsed", _state do
      assert MarketData.parse_string("12") == 12
    end

    test "check if strings representing floats are properly parsed", _state do
      assert MarketData.parse_string("12.0") == 12.0
    end

    test "check if strings representing currency pairs are properly parsed", _state do
      assert MarketData.parse_string("EUR/RON") == "EUR/RON"
    end
  end

  describe "reject invalid inputs:" do
    test "reject if inputs to file-object conversion function are integers", _state do
      assert_raise ArgumentError, "The input to convert_file_data_to_objects should be a filepath string.", fn ->
        MarketData.convert_file_data_into_objects(12)
      end
    end

    test "reject if inputs to file-object conversion function are floats", _state do
      assert_raise ArgumentError, "The input to convert_file_data_to_objects should be a filepath string.", fn ->
        MarketData.convert_file_data_into_objects(3.14159)
      end
    end

    test "reject if input to file-object conversion function is a non-existent file", _state do
      assert_raise RuntimeError, "The file doesn't exist.", fn ->
        MarketData.convert_file_data_into_objects("res/non_existent_file.hs")
      end
    end

    test "reject if input to file-object conversion function is an empty file", state do
      assert_raise RuntimeError, "The file is empty.", fn ->
        MarketData.convert_file_data_into_objects(state[:empty_filepath])
      end
    end
  end
end
