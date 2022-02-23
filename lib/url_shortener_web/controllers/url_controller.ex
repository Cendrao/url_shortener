defmodule ShortenerWeb.UrlController do
  use ShortenerWeb, :controller

  alias Shortener.{URL, URLs}

  def index(conn, _params) do
    render(conn, "index.html", shortened_url: nil)
  end

  def create(conn, params) do
    case URLs.find_or_create_url(params["original_url"]) do
      {:ok, url} ->
        shortened_url = shortened_url(url)
        render(conn, "index.html", shortened_url: shortened_url)

      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> render("index.html", shortened_url: nil)
    end
  end

  def show(conn, params) do
    case URLs.find_by_slug(params["slug"]) do
      nil ->
        conn
        |> put_flash(:error, "URL not found, please check the URL and try again.")
        |> render("index.html", shortened_url: nil)

      url ->
        redirect(conn, external: url.original_url)
    end
  end

  defp shortened_url(%URL{} = url) do
    host = ShortenerWeb.Endpoint.url()
    "#{host}/#{url.slug}"
  end
end
