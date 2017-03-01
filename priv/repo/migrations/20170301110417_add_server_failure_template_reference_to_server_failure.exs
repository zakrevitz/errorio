defmodule Errorio.Repo.Migrations.AddServerFailureTemplateReferenceToServerFailure do
  use Ecto.Migration

  def change do
    alter table(:server_failures) do
      add :server_failure_template_id, references(:server_failure_templates, on_delete: :nothing)
    end
    create index(:server_failures, [:server_failure_template_id])
  end
end
