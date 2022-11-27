defmodule UrlShortener.TinyUrls.TinyUrl do
  @moduledoc """
  Schema. Note `:shortened_url` will be updated right after a new row is inserted.
  It is not expected that it will be populated beforehand.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: __MODULE__

  schema "tiny_urls" do
    field :hit_count, :integer, default: 0
    field :shortened_url, :string
    field :url, :string
    field :hashed_url, :string

    timestamps()
  end

  @doc false
  def changeset(tiny_url, attrs) do
    tiny_url
    # TODO: add URL validation
    |> cast(attrs, [:url, :shortened_url, :hit_count, :hashed_url])
    |> validate_required([:url, :hashed_url])
    |> unique_constraint(:hashed_url)
  end
end
