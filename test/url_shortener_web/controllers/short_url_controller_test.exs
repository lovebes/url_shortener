defmodule UrlShortenerWeb.ShortUrlControllerTest do
  use UrlShortenerWeb.ConnCase
  alias UrlShortener.TinyUrls
  import UrlShortener.TinyUrlsFixtures

  defp create_tiny_url(_) do
    tiny_url = tiny_url_fixture(%{url: "http://haha.com", shortened_url: "short_url"})

    %{tiny_url: tiny_url}
  end

  describe "redirection" do
    setup [:create_tiny_url]

    test "GET /tiny should redirect on valid short url and increment hit count", %{
      conn: conn,
      tiny_url: tiny_url
    } do
      conn = get(conn, ~p"/short_url")
      prev_hit_count = tiny_url.hit_count
      assert "http://haha.com" = redirected_to(conn, 302)
      updated_tiny_url = TinyUrls.get_tiny_url!(tiny_url.id)
      assert prev_hit_count + 1 == updated_tiny_url.hit_count
    end

    test "GET /tiny should show error page on invalid short url", %{conn: conn} do
      conn = get(conn, ~p"/something_wrong")
      assert conn.status == 404
    end
  end
end
