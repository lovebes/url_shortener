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
    valid_url = "http://some.valid.com/url?with=params"

    attrs
    |> Enum.into(%{
      hit_count: 42,
      shortened_url: nil,
      url: valid_url,
      hashed_url: Shortener.hash_url(valid_url)
    })
  end
end
