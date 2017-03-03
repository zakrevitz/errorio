defmodule Errorio.Repo.Migrations.CreateEventTransitionLog do
  use Ecto.Migration

  def change do
    create table(:event_transition_logs) do
      add :info, :text
      add :server_failure_template_id, references(:server_failure_templates, on_delete: :nothing)
      add :responsible_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:event_transition_logs, [:server_failure_template_id])
    create index(:event_transition_logs, [:responsible_id])

  end
end
