defmodule Errorio.Repo.Migrations.AddPriorityToServerFailureTemplates do
  use Ecto.Migration

  def change do
    alter table(:server_failure_templates) do
      add :priority, :integer, default: 0
    end
  end
end
