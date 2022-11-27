defmodule UrlShortener.Repo.Migrations.TinyUrlsAddHashColumn do
  use Ecto.Migration

  def change do
    alter table("tiny_urls") do
      add :hashed_url, :string
    end
  end
end
