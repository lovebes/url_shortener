defmodule UrlShortener.Repo.Migrations.TinyUrlsUniqueConstraintHashedUrl do
  use Ecto.Migration

  def change do
    create unique_index("tiny_urls", [:hashed_url])
  end
end
