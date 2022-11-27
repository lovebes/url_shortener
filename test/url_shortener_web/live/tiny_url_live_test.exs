defmodule UrlShortenerWeb.TinyUrlLiveTest do
  use UrlShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import UrlShortener.TinyUrlsFixtures

  @create_attrs %{hit_count: 42, shortened_url: "some shortened_url", url: "some url"}
  @update_attrs %{
    hit_count: 43,
    shortened_url: "some updated shortened_url",
    url: "some updated url"
  }
  @invalid_attrs %{hit_count: nil, shortened_url: nil, url: nil}

  defp create_tiny_url(_) do
    tiny_url = tiny_url_fixture()
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

      assert index_live
             |> form("#tiny_url-form", tiny_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tiny_url-form", tiny_url: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tiny_urls")

      assert html =~ "Tiny url created successfully"
      assert html =~ "some shortened_url"
    end

    test "updates tiny_url in listing", %{conn: conn, tiny_url: tiny_url} do
      {:ok, index_live, _html} = live(conn, ~p"/tiny_urls")

      assert index_live |> element("#tiny_urls-#{tiny_url.id} a", "Edit") |> render_click() =~
               "Edit Tiny url"

      assert_patch(index_live, ~p"/tiny_urls/#{tiny_url}/edit")

      assert index_live
             |> form("#tiny_url-form", tiny_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tiny_url-form", tiny_url: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tiny_urls")

      assert html =~ "Tiny url updated successfully"
      assert html =~ "some updated shortened_url"
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

    test "updates tiny_url within modal", %{conn: conn, tiny_url: tiny_url} do
      {:ok, show_live, _html} = live(conn, ~p"/tiny_urls/#{tiny_url}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tiny url"

      assert_patch(show_live, ~p"/tiny_urls/#{tiny_url}/show/edit")

      assert show_live
             |> form("#tiny_url-form", tiny_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tiny_url-form", tiny_url: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tiny_urls/#{tiny_url}")

      assert html =~ "Tiny url updated successfully"
      assert html =~ "some updated shortened_url"
    end
  end
end
