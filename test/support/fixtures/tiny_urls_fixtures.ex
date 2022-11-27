defmodule UrlShortener.TinyUrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.TinyUrls` context.
  """

  @doc """
  Generate a tiny_url.
  """
  def tiny_url_fixture(attrs \\ %{}) do
    {:ok, tiny_url} =
      attrs
      |> Enum.into(%{
        hit_count: 42,
        shortened_url: "some shortened_url",
        url: "some url"
      })
      |> UrlShortener.TinyUrls.create_tiny_url()

    tiny_url
  end
end
