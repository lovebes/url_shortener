defmodule UrlShortenerWeb.TinyUrlLiveTest do
  alias UrlShortener.TinyUrls
  alias UrlShortener.TinyUrls.Shortener
  use UrlShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import UrlShortener.TinyUrlsFixtures

  @create_attrs %{
    url: "http://some.url.com"
  }
  @update_attrs %{
    hit_count: 43,
    shortened_url: "some updated shortened_url",
    hashed_url: "updated hashed url",
    url: "http://udpated.url.com"
  }
  @invalid_attrs %{hit_count: nil, shortened_url: nil, url: nil, hashed_url: nil}

  defp create_tiny_url(_) do
    tiny_url = tiny_url_fixture(%{shortened_url: "short url"})
    %{tiny_url: tiny_url}
  end

  describe "Index" do
    setup [:create_tiny_url]

    test "lists all tiny_urls", %{conn: conn, tiny_url: tiny_url} do
      {:ok, _index_live, html} = live(conn, ~p"/tiny_urls")
      assert html =~ "Listing Tiny urls"
      assert html =~ tiny_url.shortened_url
    end

    test "saves new tiny_url", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tiny_urls")

      assert index_live |> element("a", "New Tiny url") |> render_click() =~
               "New Tiny url"

      assert_patch(index_live, ~p"/tiny_urls/new")

      {:ok, _, html} =
        index_live
        |> form("#tiny_url-form", tiny_url: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tiny_urls")

      assert html =~ "Tiny url created successfully"
      inserted = TinyUrls.list_tiny_urls() |> hd
      assert html =~ inserted.shortened_url
    end

    test "deletes tiny_url in listing", %{conn: conn, tiny_url: tiny_url} do
      {:ok, index_live, _html} = live(conn, ~p"/tiny_urls")

      assert index_live |> element("#tiny_urls-#{tiny_url.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tiny_url-#{tiny_url.id}")
    end
  end

  describe "Show" do
    setup [:create_tiny_url]

    test "displays tiny_url", %{conn: conn, tiny_url: tiny_url} do
      {:ok, _show_live, html} = live(conn, ~p"/tiny_urls/#{tiny_url}")

      assert html =~ "Show Tiny url"
      assert html =~ tiny_url.shortened_url
    end
  end
end
