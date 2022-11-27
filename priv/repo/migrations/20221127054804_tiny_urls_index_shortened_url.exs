defmodule UrlShortener.Repo.Migrations.TinyUrlsIndexShortenedUrl do
  use Ecto.Migration

  def change do
    create index("tiny_urls", [:shortened_url])
  end
end
