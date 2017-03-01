defmodule Errorio.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :template, :string
      add :api_key, :string, null: false

      timestamps()
    end

  end
end
