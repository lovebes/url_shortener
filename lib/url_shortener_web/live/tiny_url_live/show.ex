defmodule UrlShortenerWeb.TinyUrlLive.Show do
  use UrlShortenerWeb, :live_view
  import UrlShortenerWeb.TinyUrlLive.Components
  alias UrlShortener.TinyUrls

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tiny_url, TinyUrls.get_tiny_url!(id))}
  end

  defp page_title(:show), do: "Show Tiny url"
  defp page_title(:edit), do: "Edit Tiny url"
end
