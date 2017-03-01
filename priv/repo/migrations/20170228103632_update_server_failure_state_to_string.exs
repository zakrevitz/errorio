defmodule Errorio.Repo.Migrations.UpdateServerFailureStateToString do
  use Ecto.Migration

  def change do
    alter table(:server_failures) do
      modify :state, :string, default: "to_do"
    end
  end
end
