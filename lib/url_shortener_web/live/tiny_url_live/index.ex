defmodule UrlShortenerWeb.TinyUrlLive.Index do
  use UrlShortenerWeb, :live_view
  import UrlShortenerWeb.TinyUrlLive.Components
  alias UrlShortener.TinyUrls

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tiny_urls, list_tiny_urls())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tiny urls")
    |> assign(:tiny_url, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tiny_url = TinyUrls.get_tiny_url!(id)
    {:ok, _} = TinyUrls.delete_tiny_url(tiny_url)

    {:noreply, assign(socket, :tiny_urls, list_tiny_urls())}
  end

  defp list_tiny_urls do
    TinyUrls.list_tiny_urls()
  end
end
