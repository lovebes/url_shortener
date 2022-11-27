defmodule UrlShortener.Repo.Migrations.CreateTinyUrls do
  use Ecto.Migration

  def change do
    create table(:tiny_urls) do
      add :url, :string
      add :shortened_url, :string
      add :hit_count, :integer

      timestamps()
    end
  end
end
