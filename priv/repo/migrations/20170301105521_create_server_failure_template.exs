defmodule Errorio.Repo.Migrations.CreateServerFailureTemplate do
  use Ecto.Migration

  def change do
    create table(:server_failure_templates) do
      add :server_failure_count, :integer, null: false, default: 0
      add :md5_hash, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps()
    end
    create index(:server_failure_templates, [:user_id])
    create index(:server_failure_templates, [:project_id])
    create index(:server_failure_templates, [:md5_hash])

  end
end
