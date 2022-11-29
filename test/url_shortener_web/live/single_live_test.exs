defmodule UrlShortenerWeb.SingleLiveTest do
  alias UrlShortener.TinyUrls
  alias UrlShortener.TinyUrls.Shortener
  use UrlShortenerWeb.ConnCase

  import Phoenix.LiveViewTest
  import UrlShortener.TinyUrlsFixtures

  @valid_url "http://some.url.com"

  @create_attrs %{
    url: @valid_url
  }

  defp create_tiny_url(_) do
    tiny_url = tiny_url_fixture(%{shortened_url: "short url"})
    %{tiny_url: tiny_url}
  end

  describe "Single" do
    setup [:create_tiny_url]

    test "saves new tiny_url and shows link to go to shortened url", %{conn: conn} do
      {:ok, single_live, _html} = live(conn, ~p"/")

      html =
        single_live
        |> form("#tiny_url-form", tiny_url: @create_attrs)
        |> render_submit()

      assert html =~ "Created (or Retrieved) Url!"
      inserted = @valid_url |> Shortener.hash_url() |> TinyUrls.get_tiny_url_by_hash()
      expect_url = "#{UrlShortenerWeb.Endpoint.url()}/#{inserted.shortened_url}"
      assert html =~ expect_url

      single_live
      |> element(~s{a[target="_new"][href="/#{inserted.shortened_url}"]})
      |> render_click()

      assert_redirect(single_live, "/#{inserted.shortened_url}")
    end
  end
end
