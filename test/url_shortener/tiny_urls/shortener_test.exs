defmodule UrlShortener.TinyUrls.ShortenerTest do
  use ExUnit.Case
  alias UrlShortener.TinyUrls.Shortener

  describe "shorten_url" do
    test "maps correctly to shortened mapped string" do
      expected = 40 |> Integer.to_string(16) |> String.downcase()
      assert Shortener.shorten_url("http://some/url.com", 40) == expected
    end
  end

  describe "hash_url" do
    test "maps correctly to shortened mapped string" do
      expected = "http://some.url" |> :crypto.hash(:md5, "Elixir\n") |> Base.encode16()
      assert Shortener.hash_url("http://some.url") == expected
    end
  end
end
