defmodule UrlShortener.TinyUrls do
  @moduledoc """
  The TinyUrls context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.TinyUrls.TinyUrl

  @doc """
  Returns the list of tiny_urls.

  ## Examples

      iex> list_tiny_urls()
      [%TinyUrl{}, ...]

  """
  def list_tiny_urls do
    Repo.all(TinyUrl)
  end

  @doc """
  Gets a single tiny_url.

  Raises `Ecto.NoResultsError` if the Tiny url does not exist.

  ## Examples

      iex> get_tiny_url!(123)
      %TinyUrl{}

      iex> get_tiny_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tiny_url!(id), do: Repo.get!(TinyUrl, id)

  @doc """
  Creates a tiny_url.

  ## Examples

      iex> create_tiny_url(%{field: value})
      {:ok, %TinyUrl{}}

      iex> create_tiny_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tiny_url(attrs \\ %{}) do
    %TinyUrl{}
    |> TinyUrl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tiny_url.

  ## Examples

      iex> update_tiny_url(tiny_url, %{field: new_value})
      {:ok, %TinyUrl{}}

      iex> update_tiny_url(tiny_url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tiny_url(%TinyUrl{} = tiny_url, attrs) do
    tiny_url
    |> TinyUrl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tiny_url.

  ## Examples

      iex> delete_tiny_url(tiny_url)
      {:ok, %TinyUrl{}}

      iex> delete_tiny_url(tiny_url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tiny_url(%TinyUrl{} = tiny_url) do
    Repo.delete(tiny_url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tiny_url changes.

  ## Examples

      iex> change_tiny_url(tiny_url)
      %Ecto.Changeset{data: %TinyUrl{}}

  """
  def change_tiny_url(%TinyUrl{} = tiny_url, attrs \\ %{}) do
    TinyUrl.changeset(tiny_url, attrs)
  end
end
