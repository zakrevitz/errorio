defmodule Errorio.Repo.Migrations.CreateServerFailure do
  use Ecto.Migration

  def change do
    create table(:server_failures) do
      add :title, :string, default: ""
      add :request, :string, default: ""
      add :processed_by, :string, default: ""
      add :exception, :string, default: ""
      add :host, :string, default: ""
      add :backtrace, :string, default: ""
      add :server, :string, default: ""
      add :params, :string, default: ""
      add :state, :integer, default: 0

      timestamps()
    end
    create index(:server_failures, [:server])
    create index(:server_failures, [:title])
  end
end
