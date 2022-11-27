defmodule UrlShortener.TinyUrlsTest do
  use UrlShortener.DataCase

  alias UrlShortener.TinyUrls

  describe "tiny_urls" do
    alias UrlShortener.TinyUrls.TinyUrl

    import UrlShortener.TinyUrlsFixtures

    @invalid_attrs %{hit_count: nil, shortened_url: nil, url: nil}

    test "list_tiny_urls/0 returns all tiny_urls" do
      tiny_url = tiny_url_fixture()
      assert TinyUrls.list_tiny_urls() == [tiny_url]
    end

    test "get_tiny_url!/1 returns the tiny_url with given id" do
      tiny_url = tiny_url_fixture()
      assert TinyUrls.get_tiny_url!(tiny_url.id) == tiny_url
    end

    test "get_tiny_url_by_hash/1 returns the tiny_url with given id" do
      tiny_url = tiny_url_fixture()
      assert TinyUrls.get_tiny_url_by_hash(tiny_url.hashed_url) == tiny_url
    end

    test "create_tiny_url/1 with valid data creates a tiny_url" do
      valid_attrs = %{hit_count: 42, shortened_url: "some shortened_url", url: "some url"}

      assert {:ok, %TinyUrl{} = tiny_url} = TinyUrls.create_tiny_url(valid_attrs)
      assert tiny_url.hit_count == 42
      assert tiny_url.shortened_url == "some shortened_url"
      assert tiny_url.url == "some url"
    end

    test "create_tiny_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TinyUrls.create_tiny_url(@invalid_attrs)
    end

    test "update_tiny_url/2 with valid data updates the tiny_url" do
      tiny_url = tiny_url_fixture()

      update_attrs = %{
        hit_count: 43,
        shortened_url: "some updated shortened_url",
        url: "some updated url"
      }

      assert {:ok, %TinyUrl{} = tiny_url} = TinyUrls.update_tiny_url(tiny_url, update_attrs)
      assert tiny_url.hit_count == 43
      assert tiny_url.shortened_url == "some updated shortened_url"
      assert tiny_url.url == "some updated url"
    end

    test "update_tiny_url/2 with invalid data returns error changeset" do
      tiny_url = tiny_url_fixture()
      assert {:error, %Ecto.Changeset{}} = TinyUrls.update_tiny_url(tiny_url, @invalid_attrs)
      assert tiny_url == TinyUrls.get_tiny_url!(tiny_url.id)
    end

    test "delete_tiny_url/1 deletes the tiny_url" do
      tiny_url = tiny_url_fixture()
      assert {:ok, %TinyUrl{}} = TinyUrls.delete_tiny_url(tiny_url)
      assert_raise Ecto.NoResultsError, fn -> TinyUrls.get_tiny_url!(tiny_url.id) end
    end

    test "change_tiny_url/1 returns a tiny_url changeset" do
      tiny_url = tiny_url_fixture()
      assert %Ecto.Changeset{} = TinyUrls.change_tiny_url(tiny_url)
    end

    test "get_or_insert_tiny_url/1 returns stored tiny url" do
      tiny_url = tiny_url_fixture()

      attrs =
        tiny_url
        |> Map.filter(fn {key, _value} -> TinyUrl.__schema__(:fields) |> Enum.member?(key) end)

      changeset = Ecto.Changeset.change(%TinyUrl{}, attrs)

      assert tiny_url == TinyUrls.get_or_insert_tiny_url(changeset)
    end

    test "get_or_insert_tiny_url/1 inserts tiny url if not found" do
      attrs = tiny_url_attrs()
      changeset = Ecto.Changeset.change(%TinyUrl{}, attrs)

      {:ok, inserted} = TinyUrls.get_or_insert_tiny_url(changeset)
      assert !is_nil(inserted.id)
      assert inserted.hashed_url == attrs.hashed_url
    end
  end
end
