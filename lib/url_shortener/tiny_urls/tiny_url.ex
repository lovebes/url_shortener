defmodule UrlShortener.TinyUrls.TinyUrl do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tiny_urls" do
    field :hit_count, :integer
    field :shortened_url, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(tiny_url, attrs) do
    tiny_url
    |> cast(attrs, [:url, :shortened_url, :hit_count])
    |> validate_required([:url, :shortened_url, :hit_count])
  end
end
