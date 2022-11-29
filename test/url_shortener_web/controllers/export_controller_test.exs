defmodule UrlShortenerWeb.ExportControllerTest do
  use UrlShortenerWeb.ConnCase
  alias UrlShortener.TinyUrls

  defp create_tiny_urls(_) do
    tiny_url1 = TinyUrls.create_tiny_url("http://haha.com")
    tiny_url2 = TinyUrls.create_tiny_url("http://haha2.com")

    %{tiny_url1: tiny_url1, tiny_url2: tiny_url2}
  end

  describe "download" do
    setup [:create_tiny_urls]

    defp csv_content(records, fields) do
      records
      |> Enum.map(fn record ->
        record
        |> Map.from_struct()
        # gives an empty map
        |> Map.take(fields)
        |> prep_data()
      end)
      |> CSV.encode(headers: fields)
      |> Enum.to_list()
      |> to_string()
    end

    defp prep_data(fields_map) do
      %{fields_map | shortened_url: full_short_url(fields_map.shortened_url)}
    end

    defp full_short_url(short_url) do
      "#{UrlShortenerWeb.Endpoint.url()}/#{short_url}"
    end

    test "GET /export should trigger download of CSV file with contents from tiny url table, with parsed short url",
         %{
           conn: conn
         } do
      conn = get(conn, ~p"/export")

      assert get_resp_header(conn, "content-disposition") ==
               ["attachment; filename=\"export.csv\""]

      assert get_resp_header(conn, "content-type") ==
               ["text/csv"]

      expected_data = csv_content(TinyUrls.list_tiny_urls(), [:url, :shortened_url, :hit_count])
      assert conn.resp_body == expected_data
    end
  end
end
