defmodule Errorio.ServerFailureTemplate do
  use Errorio.Web, :model

  schema "server_failure_templates" do
    field :server_failure_count, :integer, default: 0
    field :md5_hash, :string
    belongs_to :user, Errorio.User
    belongs_to :project, Errorio.Project

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:server_failure_count, :md5_hash])
    |> validate_required([:server_failure_count, :md5_hash])
  end
end
