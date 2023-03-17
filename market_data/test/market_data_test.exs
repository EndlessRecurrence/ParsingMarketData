defmodule MarketDataTest do
  use ExUnit.Case
  doctest MarketData

  test "check if file data is converted into objects" do
    assert MarketData.convert_file_data_into_objects() == [
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

  test "check if strings representing integers are properly parsed" do
    assert MarketData.parse_string("12") == 12
  end

  test "check if strings representing floats are properly parsed" do
    assert MarketData.parse_string("12.0") == 12.0
  end

  test "check if strings representing currency pairs are properly parsed" do
    assert MarketData.parse_string("EUR/RON") == "EUR/RON"
  end
end
