defmodule UrlShortener.CallRateTest do
  use ExUnit.Case

  @deployed_url "https://fly.io/apps/url-shortener-seungjin"

  @tag :benchmark
  test "should make at least 5 requests per second" do
    # capture benchee output to run assertions
    output =
      Benchee.run(%{
        "call form" => fn ->
          HTTPoison.get(@deployed_url)
        end
      })

    max_time_per_call_pico_sec = 60 / 5 * 1_000_000_000

    results = Enum.at(output.scenarios, 0)
    assert results.run_time_data.statistics.average <= max_time_per_call_pico_sec
  end
end
