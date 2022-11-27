defmodule UrlShortenerWeb.ShortUrlControllerTest do
  use UrlShortenerWeb.ConnCase
  import UrlShortener.TinyUrlsFixtures

  defp create_tiny_url(_) do
    tiny_url = tiny_url_fixture(%{url: "http://haha.com", shortened_url: "short_url"})

    %{tiny_url: tiny_url}
  end

  describe "redirection" do
    setup [:create_tiny_url]

    test "GET /tiny should redirect on valid short url", %{conn: conn} do
      conn = get(conn, ~p"/tiny/short_url")
      assert "http://haha.com" = redirected_to(conn, 302)
    end

    test "GET /tiny should show error page on invalid short url", %{conn: conn} do
      conn = get(conn, ~p"/tiny/something_wrong")
      assert conn.status == 404
    end
  end
end
