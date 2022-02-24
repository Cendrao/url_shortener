defmodule Shortener.URL do
  @moduledoc """
  Holds the URL schema.
  """
  use Ecto.Schema

  import Ecto.Changeset

  # credo:disable-for-next-line
  @url_regex ~r/(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/

  schema "urls" do
    field :original_url, :string
    field :slug, :string

    timestamps()
  end

  @fields ~w(original_url slug)a

  def changeset(model, attrs) do
    model
    |> cast(attrs, [:original_url])
    |> put_slug()
    |> validate_required(@fields)
    |> validate_format(:original_url, @url_regex)
    |> unique_constraint(:slug)
  end

  defp put_slug(changeset) do
    if changeset.valid? do
      slug =
        changeset
        |> get_change(:original_url)
        |> generate_slug()

      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end

  defp generate_slug(""), do: nil

  defp generate_slug(nil), do: nil

  defp generate_slug(original_url) do
    original_url
    |> Base.url_encode64()
    |> String.graphemes()
    |> Enum.shuffle()
    |> Enum.take(6)
    |> Enum.join()
  end
end
