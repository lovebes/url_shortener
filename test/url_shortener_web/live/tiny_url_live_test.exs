defmodule UrlShortenerWeb.TinyUrlLiveTest do
  use UrlShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import UrlShortener.TinyUrlsFixtures

  defp create_tiny_url(_) do
    tiny_url = tiny_url_fixture(%{shortened_url: "short url"})
    %{tiny_url: tiny_url}
  end

  describe "Index" do
    setup [:create_tiny_url]

    test "lists all tiny_urls", %{conn: conn, tiny_url: tiny_url} do
      {:ok, _index_live, html} = live(conn, ~p"/stats")
      assert html =~ "Listing Tiny urls"
      assert html =~ tiny_url.shortened_url
    end

    test "deletes tiny_url in listing", %{conn: conn, tiny_url: tiny_url} do
      {:ok, index_live, _html} = live(conn, ~p"/stats")

      assert index_live |> element("#tiny_urls-#{tiny_url.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tiny_url-#{tiny_url.id}")
    end
  end

  describe "Show" do
    setup [:create_tiny_url]

    test "displays tiny_url", %{conn: conn, tiny_url: tiny_url} do
      {:ok, _show_live, html} = live(conn, ~p"/stats/#{tiny_url}")

      assert html =~ "Show Tiny url"
      assert html =~ tiny_url.shortened_url
    end
  end
end
