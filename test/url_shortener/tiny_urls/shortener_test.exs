defmodule UrlShortener.TinyUrls.ShortenerTest do
  use ExUnit.Case
  alias UrlShortener.TinyUrls.Shortener

  describe "shorten_url" do
    test "maps correctly to shortened mapped string" do
      expected = 40 |> Integer.to_string(16) |> String.downcase()
      assert Shortener.shorten_url("http://some/url.com", 40) == expected
    end
  end
end
