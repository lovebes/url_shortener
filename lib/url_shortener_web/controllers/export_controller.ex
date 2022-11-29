defmodule UrlShortenerWeb.ExportController do
  @moduledoc """
  Module for exporting of CSV of the table for url shortening
  """
  use UrlShortenerWeb, :controller
  import Phoenix.Controller
  alias UrlShortener.TinyUrls

  @doc """
  Download CSV using the contents of the `tiny_urls` table
  """
  def download(conn, _params) do
    fields = [:url, :shortened_url, :hit_count]
    csv_data = csv_content(TinyUrls.list_tiny_urls(), fields)

    conn
    |> put_resp_content_type("text/csv")
    |> send_download({:binary, csv_data}, filename: "export.csv")

    # |> put_resp_header("content-disposition", "attachment; filename=\"export.csv\"")
    # |> put_root_layout(false)
    # |> send_resp(200, csv_data)
  end

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
end
