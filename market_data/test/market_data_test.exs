defmodule MarketDataTest do
  use ExUnit.Case
  doctest MarketData

  setup_all do
    {:ok, filepath: "res/data.txt"}
  end

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

  describe "data type conversions" do
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
end
