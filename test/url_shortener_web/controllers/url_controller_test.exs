defmodule ShortenerWeb.UrlControllerTest do
  use ShortenerWeb.ConnCase

  alias Shortener.URLs

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Shorten your URL"
  end

  describe "POST /" do
    test "with a valid URL it should ask for copy, have new shorten area and show the shorten URL",
         %{conn: conn} do
      original_url = "https://www.google.com"

      conn = post(conn, "/", %{"original_url" => original_url})

      assert response = html_response(conn, 200)
      assert response =~ "Shorten another URL"
      assert response =~ "Copy and paste the following URL or use the copy button."
      assert response =~ "http://localhost:4002/"
    end

    test "with an invalid URL it should show the error message and the shorten area", %{
      conn: conn
    } do
      original_url = "invalid.url"
      conn = post(conn, "/", %{"original_url" => original_url})

      assert response = html_response(conn, 200)
      assert response =~ "Invalid URL format, please start with http:// or https://"
      assert response =~ "Shorten my URL!"
    end
  end

  describe "GET /:slug" do
    test "with a valid slug should redirect the user to the original_url", %{conn: conn} do
      {:ok, url} = URLs.find_or_create_url("http://www.google.com")

      conn = get(conn, "/#{url.slug}")

      assert redirected_to(conn) == url.original_url
    end

    test "with an invalid slug should show an error message", %{conn: conn} do
      conn = get(conn, "/invalid_slug")

      assert response = html_response(conn, 200)

      assert response =~ "URL not found, please check the URL and try again."
    end
  end
end
