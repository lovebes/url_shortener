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
    |> cast(attrs, [:url, :shortened_url, :hit_count, :hashed_url])
    |> validate_url()
    |> validate_required([:url, :hashed_url])
    |> unique_constraint(:hashed_url)
  end

  defp validate_url(changeset) do
    changeset
    |> validate_change(:url, fn :url, url ->
      # validate via URI parsing
      if is_valid_url?(URI.parse(url)) do
        []
      else
        [url: "invalid url - scheme or host is missing"]
      end
    end)
  end

  defp is_valid_url?(%URI{scheme: scheme, host: host}) do
    !is_nil(scheme) && is_valid_host?(host)
  end

  defp is_valid_host?(nil), do: false

  defp is_valid_host?(host) do
    # bare minimum host format check to have a '.' in between
    host |> String.split(".") |> Enum.filter(&(&1 != "")) |> length >= 2
  end
end
