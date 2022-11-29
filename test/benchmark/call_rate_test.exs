defmodule UrlShortener.CallRateTest do
  use ExUnit.Case

  @deployed_url "https://url-shortener-seungjin.fly.dev/"
  @deployed_url_short_url "https://url-shortener-seungjin.fly.dev/3"

  describe "form endpoint" do
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

  describe "short url endpoint" do
    @tag :benchmark
    test "should make at least 25 requests per second" do
      # capture benchee output to run assertions
      output =
        Benchee.run(%{
          "call tiny url" => fn ->
            HTTPoison.get(@deployed_url_short_url)
          end
        })

      max_time_per_call_pico_sec = 60 / 25 * 1_000_000_000

      results = Enum.at(output.scenarios, 0)
      assert results.run_time_data.statistics.average <= max_time_per_call_pico_sec
    end
  end
end
