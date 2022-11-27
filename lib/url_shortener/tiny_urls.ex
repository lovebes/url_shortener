defmodule UrlShortener.TinyUrls do
  @moduledoc """
  The TinyUrls context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.TinyUrls.{Shortener, TinyUrl}

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
  Gets a single tiny_url by :hashed_url

  Returns `nil` if the Tiny url does not exist.

  ## Examples

      iex> get_tiny_url_by_hash("694F56F4B30E60837151723777795FC2")
      %TinyUrl{}

      iex> get_tiny_url!("da23423514")
      nil

  """
  def get_tiny_url_by_hash(hashed_url), do: Repo.get_by(TinyUrl, hashed_url: hashed_url)

  @doc """
  Gets a single tiny_url by :shortened_url

  Returns `nil` if the Tiny url does not exist.

  ## Examples

      iex> get_tiny_url_by_shortened_url("short_url_001")
      %TinyUrl{}

      iex> get_tiny_url!("wrong_short_url")
      nil

  """
  def get_tiny_url_by_shortened_url(shortened), do: Repo.get_by(TinyUrl, shortened_url: shortened)

  @doc """
  Creates a tiny_url.
  It will also create, if not exists:
    - :hashed_url

  ## Examples
      iex> create_tiny_url(%{field: value})
      {:ok, %TinyUrl{}}

      iex> create_tiny_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> create_tiny_url("some url")
      {:ok, %TinyUrl{}}

      iex> create_tiny_url("some invalid url")
      {:error, %Ecto.Changeset{}}

  """
  def create_tiny_url(url_or_attrs \\ %{})

  def create_tiny_url(url) when is_binary(url) do
    %TinyUrl{}
    |> TinyUrl.changeset(attrs_from_url(url))
    |> get_or_insert_tiny_url()
  end

  def create_tiny_url(attrs) when is_map(attrs) do
    %TinyUrl{}
    |> TinyUrl.changeset(attrs)
    |> Repo.insert()
  end

  defp attrs_from_url(url) do
    %{
      url: url,
      hashed_url: Shortener.hash_url(url)
    }
  end

  @doc """
  Either returns an existing row based on :hashed_url or inserts a valid changeset.
  Entire operation is done in a transaction.
  Returns %TinyUrl{} (existing or inserted one), or error tuple for any unexpected errors
  """
  @spec get_or_insert_tiny_url(Ecto.Changeset.t()) ::
          {:ok, TinyUrl.t()}
          | {:error, failed_operation :: atom(), failed_value :: any(), changes_so_far :: list()}
  def get_or_insert_tiny_url(%Ecto.Changeset{valid?: true} = changeset) do
    %TinyUrl{hashed_url: hashed_url} = Ecto.Changeset.apply_changes(changeset)

    Ecto.Multi.new()
    |> Ecto.Multi.one(:stored_url, from(tu in TinyUrl, where: tu.hashed_url == ^hashed_url))
    # then exit out if already exists
    |> Ecto.Multi.run(:check_exists, fn
      _repo, %{stored_url: %TinyUrl{} = existing} -> {:error, {:url_exists, existing}}
      _repo, %{stored_url: nil} -> {:ok, nil}
    end)
    |> Ecto.Multi.insert(:insert_url, changeset)
    |> Ecto.Multi.update(:update_shortened_url, fn %{insert_url: inserted} ->
      Ecto.Changeset.change(inserted,
        shortened_url: Shortener.shorten_url(inserted.url, inserted.id)
      )
    end)
    |> Repo.transaction()
    |> case do
      {:error, :check_exists, {:url_exists, existing}, _changes_so_far} ->
        {:ok, existing}

      {:ok, %{update_shortened_url: url_row_with_shortened_url}} ->
        {:ok, url_row_with_shortened_url}

      other_error ->
        other_error
    end
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
