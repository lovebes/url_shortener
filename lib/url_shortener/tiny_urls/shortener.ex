defmodule UrlShortener.TinyUrls.Shortener do
  @moduledoc """
  URL Shortener logic handler module

  Main idea of the URL shortening is that we increment an integer value and that number, in base64 form, will be the shortened URL.
  The integer value is the incrementing PK of the `tiny_urls` table. Using the PK prevents us from having collisions to some degree.

  Using MD5, another column will be storing the hashed url, and a unique-constrained index for it will be created.
  Look up will be done so as to prevent duplicate urls getting into the table.

  ## Note
  Url validation check is handled by some other module. This module only handles the mapping.

  ## Example:

  Next index value: 30
  Url: https://www.google.com
  => mapped shortened_url: hex(30) => `1e`

  """

  alias UrlShortener.Repo
  alias UrlShortener.TinyUrls.TinyUrl

  @doc """
  Shortens the url using strategy of doing hex-representation of next_index
  Returns lowercased hex digits in string form.

  TODO: make it check if it exists in dB, and use stored index if exists
  """
  @spec shorten_url(url :: binary, next_index :: number()) :: binary()
  def shorten_url(_url, next_index) do
    next_index |> Integer.to_string(16) |> String.downcase()
  end

  @doc """
  Hashes the url using MD5 hash
  """
  @spec hash_url(url :: binary()) :: binary()
  def hash_url(url) do
    :crypto.hash(:md5, url) |> Base.encode16()
  end
end
