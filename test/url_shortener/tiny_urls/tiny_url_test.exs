defmodule UrlShortener.TinyUrls.TinyUrlTest do
  use UrlShortener.DataCase

  alias UrlShortener.TinyUrls.{Shortener, TinyUrl}
  alias UrlShortener.Repo

  describe "changeset" do
    test "should prevent same url to be inserted if hashed_url is the same" do
      url = "http://some.url.com"
      hashed_url = :crypto.hash(:md5, url) |> Base.encode16()

      TinyUrl.changeset(%TinyUrl{}, %{url: url, shortened_url: "shrt", hashed_url: hashed_url})
      |> Repo.insert!()

      assert {:error, %Ecto.Changeset{} = changeset} =
               TinyUrl.changeset(%TinyUrl{}, %{
                 url: url,
                 shortened_url: "shrt",
                 hashed_url: hashed_url
               })
               |> Repo.insert()

      assert %{hashed_url: ["has already been taken"]} = errors_on(changeset)
    end

    test "should error on invalid url" do
      url = "http://.com"

      hashed_url = Shortener.hash_url(url)

      changeset =
        TinyUrl.changeset(%TinyUrl{}, %{
          url: url,
          shortened_url: "shrt",
          hashed_url: hashed_url
        })

      assert %{url: ["invalid url - scheme or host is missing"]} = errors_on(changeset)
    end

    test "should be valid changeset for valid url" do
      url = "http://some.com"

      hashed_url = Shortener.hash_url(url)

      assert %Ecto.Changeset{valid?: true} =
               TinyUrl.changeset(%TinyUrl{}, %{
                 url: url,
                 shortened_url: "shrt",
                 hashed_url: hashed_url
               })
    end
  end
end
