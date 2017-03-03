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
    field :last_time_seen_at, :naive_datetime
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

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:md5_hash, :title, :processed_by, :params])
    |> validate_required([:md5_hash, :title])
  end

  def create_child_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> cast_assoc(:server_failures, required: true)
  end

  def assign_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
  end

  def can_assign?(model, user_id) do
    case model.assignee do
      nil ->
        true
      assignee ->
        case assignee.id do
          ^user_id ->
            false
          _ ->
            true
        end
    end
  end

  def assign(model, user) do
    case model do
      {:ok, server_failure_template} ->
        update_assignee(server_failure_template, user.id)
      {:error, reason} -> {:error, reason}
      server_failure_template ->
        update_assignee(server_failure_template, user.id)

    end
  end

  def update_assignee(server_failure_template, user_id) do
    result = server_failure_template
    |> assign_changeset(%{user_id: user_id})
    |> Errorio.Repo.update
  end

  def last_time_seen(server_failure_template) do
  end
end
