defmodule Shortener.URLTest do
  use Shortener.DataCase

  alias Shortener.URL

  describe "changeset/2" do
    test "with a valid url should be valid" do
      assert URL.changeset(%URL{}, %{original_url: "https://www.google.com"})
      assert URL.changeset(%URL{}, %{original_url: "http://www.google.com"})
      assert URL.changeset(%URL{}, %{original_url: "https://www.apple.com"})

      assert URL.changeset(%URL{}, %{
               original_url: "https://www.example.org/with/not/so/long/path"
             })

      assert URL.changeset(%URL{}, %{
               original_url:
                 "https://www.example.org/with/long/query?q=89fahjsa9231j12AJSJJAKSJDDKASJ93412jfdasjkldas0r230980j9asdkljk234lkj432jfads9fd9asja"
             })
    end

    test "with invalid formats should not be valid" do
      refute URL.changeset(%URL{}, %{original_url: "goo.com"}).valid?
      refute URL.changeset(%URL{}, %{original_url: ""}).valid?
      refute URL.changeset(%URL{}, %{original_url: nil}).valid?
      refute URL.changeset(%URL{}, %{original_url: 123}).valid?
      refute URL.changeset(%URL{}, %{original_url: "https//google.com"}).valid?
      refute URL.changeset(%URL{}, %{original_url: "http//google.com"}).valid?
    end

    test "should generate different slugs" do
      %Ecto.Changeset{changes: %{slug: first_slug}} =
        URL.changeset(%URL{}, %{"original_url" => "https://youtube.com"})

      %Ecto.Changeset{changes: %{slug: second_slug}} =
        URL.changeset(%URL{}, %{"original_url" => "https://google.com"})

      assert first_slug != second_slug
    end
  end
end
