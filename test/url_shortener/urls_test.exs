defmodule Shortener.URLsTest do
  use Shortener.DataCase

  alias Shortener.{URL, URLs}

  describe "find_or_create_url/1" do
    test "when a new original url is given should create a new one" do
      {:ok, actual} = URLs.find_or_create_url("https://www.google.com")

      assert %URL{original_url: "https://www.google.com", slug: slug} = actual
      assert slug
    end

    test "should return the same slug for the same original_url" do
      google = URL.changeset(%URL{}, %{original_url: "https://www.google.com"}) |> Repo.insert!()

      {:ok, actual} = URLs.find_or_create_url("https://www.google.com")

      assert actual == google
    end

    test "with an invalid url should return an error" do
      {:error, error} = URLs.find_or_create_url("123456")

      assert error == "Invalid URL format, please start with http:// or https://"
    end
  end

  describe "find_by_slug/1" do
    test "with a valid slug should return the URL" do
      %URL{slug: slug} =
        google =
        URL.changeset(%URL{}, %{original_url: "https://www.google.com"}) |> Repo.insert!()

      actual = URLs.find_by_slug(slug)

      assert actual == google
    end

    test "with an invalid slug should return nil" do
      refute URLs.find_by_slug("invalid_slug")
    end
  end
end
