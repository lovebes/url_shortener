defmodule UrlShortenerWeb.TinyUrlLive.Components do
  @moduledoc """
  Assorted group of UI helper components
  """
  use UrlShortenerWeb, :html
  alias UrlShortenerWeb.Endpoint

  @doc """
  Renders a link using the shortened url.

  :inner_block slot becomes the inner DOM, e.g. <a>__HERE__</a>
  ## Examples

      <.short_url shortened_url="23" />
  """
  attr :shortened_url, :string, default: nil
  attr :class, :string, default: nil

  def short_url(assigns) do
    ~H"""
    <a
      href={~p"/#{@shortened_url}"}
      target="_new"
      class={[
        "underline text-blue-800 rounded-lg border-2 border-blue-300 hover:border-blue-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
    >
      <%= "#{Endpoint.url()}/#{@shortened_url}" %>
    </a>
    """
  end
end
