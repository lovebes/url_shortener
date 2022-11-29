defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UrlShortenerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UrlShortenerWeb do
    pipe_through :browser

    live "/", TinyUrlLive.Single, :new
    get "/tiny/:short_url", ShortUrlController, :redirect_to_url
    live "/stats", TinyUrlLive.Index, :index

    live "/tiny_urls/:id", TinyUrlLive.Show, :show
  end
end
