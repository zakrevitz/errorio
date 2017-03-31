defmodule Errorio.Repo.Migrations.UpdateServerFailures do
  use Ecto.Migration

  def up do
    alter table(:server_failures) do
      modify :title, :text
      modify :request, :text
      modify :processed_by, :text
      modify :exception, :text
      modify :host, :text
      modify :server, :text

      remove :params
      remove :backtrace

      add :params, :map
      add :backtrace, {:array, :map}
      add :session, :map
      add :headers, :map
      add :context, :map
    end
  end

  def down do
    alter table(:server_failures) do
      modify :title, :string
      modify :request, :string
      modify :processed_by, :string
      modify :exception, :string
      modify :host, :string
      modify :server, :string

      remove :params
      remove :session
      remove :headers
      remove :context
      remove :backtrace

      add :params, :string
      add :backtrace, :string
    end
  end
end
