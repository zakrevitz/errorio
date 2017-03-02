defmodule Errorio.Repo.Migrations.AddFieldsToServerFailureTemplate do
  use Ecto.Migration

  def change do
    alter table(:server_failure_templates) do
      add :title, :string, default: ""
      add :processed_by, :string, default: ""
      add :params, :string, default: ""
    end
  end
end
