defmodule Errorio.ServerFailureTemplate do
  use Errorio.Web, :model

  use EctoStateMachine,
    states: [:to_do, :in_progress, :to_check, :done, :reopened],
    events: [
      [
        name:     :start,
        from:     [:to_do],
        to:       :in_progress
      ], [
        name:     :move_to_check,
        from:     [:to_do, :in_progress],
        to:       :to_check
      ], [
        name:     :close,
        from:     [:in_progress, :to_check, :reopened],
        to:       :done
      ], [
        name:     :reopen,
        from:     [:done],
        to:       :reopened
      ], [
        name:     :confirm,
        from:     [:reopened],
        to:       :to_do
      ]
    ]

  schema "server_failure_templates" do
    field :server_failure_count, :integer, default: 0
    field :md5_hash, :string
    field :title, :string
    field :processed_by, :string
    field :params, :string
    field :state, :string, default: "to_do"
    belongs_to :assignee, Errorio.User, foreign_key: :user_id
    belongs_to :project, Errorio.Project
    has_many :server_failures, Errorio.ServerFailure

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:server_failure_count, :md5_hash, :state])
    |> validate_required([:server_failure_count, :md5_hash])
  end

  def assign_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
  end
end
