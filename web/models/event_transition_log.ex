defmodule Errorio.EventTransitionLog do
  use Errorio.Web, :model

  schema "event_transition_logs" do
    field :info, :string
    belongs_to :server_failure_template, Errorio.ServerFailureTemplate
    belongs_to :responsible, Errorio.User, foreign_key: :responsible_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:info, :responsible_id])
    |> validate_required([:info, :responsible_id])
  end
end
