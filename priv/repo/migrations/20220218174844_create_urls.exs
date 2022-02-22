defmodule Shortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :original_url, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:urls, [:slug])
  end
end
