defmodule UrlShortener.TinyUrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.TinyUrls` context.
  """
  alias UrlShortener.TinyUrls.Shortener

  @doc """
  Generate a tiny_url.
  """
  def tiny_url_fixture(attrs \\ %{}) do
    {:ok, tiny_url} =
      tiny_url_attrs(attrs)
      |> UrlShortener.TinyUrls.create_tiny_url()

    tiny_url
  end

  @doc """
  Returns attrs for %TinyUrl{}
  """
  def tiny_url_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      hit_count: 42,
      shortened_url: "some shortened_url",
      url: "some url",
      hashed_url: Shortener.hash_url("some url")
    })
  end
end
