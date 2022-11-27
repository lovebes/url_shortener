defmodule UrlShortenerWeb.ShortUrlController do
  use UrlShortenerWeb, :controller
  import UrlShortener.TinyUrls

  @doc """
  Use incoming param to fetch the short_url, and then increment hit count + redirect
  """
  def redirect_to_url(conn, %{"short_url" => short_url}) do
    case get_tiny_url_by_shortened_url(short_url) do
      nil -> raise Ecto.NoResultsError
      tiny_url -> redirect(conn, external: tiny_url.url)
    end
  end
end
