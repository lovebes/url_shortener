defmodule UrlShortener.Repo.Migrations.TinyUrlIncreaseUrlFieldVarchar do
  use Ecto.Migration

  def change do
    alter table(:tiny_urls) do
      modify :url, :text
    end
  end
end
