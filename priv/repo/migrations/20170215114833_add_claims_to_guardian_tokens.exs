defmodule Errorio.Repo.Migrations.AddClaimsToGuardianTokens do
  use Ecto.Migration

  def change do
    alter table(:guardian_tokens) do
      add :claims, :map
    end
  end
end
