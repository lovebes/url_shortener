defmodule UrlShortenerWeb.TinyUrlLive.Single do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.TinyUrls
  alias UrlShortener.TinyUrls.TinyUrl

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tiny_urls, list_tiny_urls())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tiny url")
    |> assign(:tiny_url, %TinyUrl{})
  end

  defp list_tiny_urls do
    TinyUrls.list_tiny_urls()
  end
end
