defmodule Errorio.Repo.Migrations.AddLastSeenToServerFailureTemplates do
  use Ecto.Migration

  def change do
    alter table(:server_failure_templates) do
      add :last_time_seen_at, :datetime
    end
  end
end
