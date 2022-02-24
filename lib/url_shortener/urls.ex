defmodule Shortener.URLs do
  @moduledoc """
  Hold business logic for URLs such as URL creations.
  """

  alias Shortener.{Repo, URL}

  require Logger

  def find_or_create_url(original_url) do
    with nil <- Repo.get_by(URL, original_url: original_url),
         {:ok, url} <- create_url(original_url) do
      {:ok, url}
    else
      %URL{} = url ->
        {:ok, url}

      {:error, %Ecto.Changeset{errors: [original_url: {_, [validation: :format]}]}} ->
        {:error, "Invalid URL format, please start with http:// or https://"}

      {:error, error} ->
        Logger.error("[CREATE URLs] Error creating URL: #{inspect(error)}")
        {:error, "Something went wrong, please try again later."}
    end
  end

  def find_by_slug(slug) do
    Repo.get_by(URL, slug: slug)
  end

  defp create_url(original_url) do
    changeset = URL.changeset(%URL{}, %{original_url: original_url})
    Repo.insert(changeset)
  end
end
