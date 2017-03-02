defmodule Errorio.Repo.Migrations.AddStateToServerFailureTemplates do
  use Ecto.Migration

  def change do
    alter table(:server_failure_templates) do
      add :state, :string, default: "to_do"
    end

    alter table(:server_failures) do
      remove :state
    end
  end
end
