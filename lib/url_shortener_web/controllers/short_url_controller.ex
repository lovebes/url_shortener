defmodule UrlShortenerWeb.ShortUrlController do
  use UrlShortenerWeb, :controller
  require Logger
  import UrlShortener.TinyUrls

  @doc """
  Use incoming param to fetch the short_url, and then increment hit count + redirect
  """
  def redirect_to_url(conn, %{"short_url" => short_url}) do
    case get_tiny_url_by_shortened_url(short_url) do
      nil ->
        conn
        |> Plug.Conn.put_status(404)
        |> text("unable to find url")

      tiny_url ->
        incr_hit_and_redirect(conn, tiny_url)
        redirect(conn, external: tiny_url.url)
    end
  end

  defp incr_hit_and_redirect(conn, tiny_url) do
    update_tiny_url(tiny_url, %{hit_count: tiny_url.hit_count + 1})
    |> case do
      {:ok, _} ->
        redirect(conn, external: tiny_url.url)

      {:error, err} ->
        Logger.warn("incr_hit_and_redirect: failed to update hit count. Error: #{inspect(err)}")
        redirect(conn, external: tiny_url.url)
    end
  end
end
