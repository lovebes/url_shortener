defmodule UrlShortener.TinyUrls.TinyUrlTest do
  use UrlShortener.DataCase

  alias UrlShortener.TinyUrls.TinyUrl
  alias UrlShortener.Repo

  describe "unique constraint" do
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
  end
end
