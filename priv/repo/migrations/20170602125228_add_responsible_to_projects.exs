defmodule Errorio.Repo.Migrations.AddResponsibleToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :responsible_id, references(:users, on_delete: :nothing)
    end
  end
end
