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
    field :priority, PriorityType
    belongs_to :assignee, Errorio.User, foreign_key: :user_id
    belongs_to :project, Errorio.Project
    has_many :server_failures, Errorio.ServerFailure
    has_many :event_transition_logs, Errorio.EventTransitionLog

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
    |> cast(params, [:md5_hash, :title, :processed_by, :params, :project_id])
    |> validate_required([:md5_hash, :title, :project_id])
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

  def log_transition(new_template, old_template, responsible) do
    case new_template do
      {:ok, server_failure_template} ->
        params = %{info: generate_info(old_template, server_failure_template, responsible.name), responsible_id: responsible.id}
        server_failure_template
        |> Ecto.build_assoc(:event_transition_logs)
        |> Errorio.EventTransitionLog.changeset(params)
        |> Errorio.Repo.insert
        new_template
      {:error, reason} -> {:error, reason}
    end
  end

  def update_assignee(server_failure_template, user_id) do
    server_failure_template
    |> assign_changeset(%{user_id: user_id})
    |> Errorio.Repo.update
  end

  def statistics(query) do
    (from se in query,
      select: %{
        unassigned: fragment("count(case when user_id IS NULL then 1 else null end)"),
        unresolved: fragment("count(case when state = 'to_do' then 1 else null end)"),
        in_progress: fragment("count(case when state = 'in_progress' then 1 else null end)"),
        reopened: fragment("count(case when state = 'reopened' then 1 else null end)")
      }
    ) |> Errorio.Repo.one
  end

  def priority_id(model) do
    Keyword.get(PriorityType.__enum_map__(), model.priority, 0)
  end

  def filter(changeset, params, current_user) do
    project_id = Map.get(params, "project_id", nil)
    assigned = Map.get(params, "assigned", nil)
    state = Map.get(params, "state", nil)
    sort = Map.get(params, "sort", nil)
    date_from = Map.get(params, "date_from", nil)
    date_to = Map.get(params, "date_to", nil)

    changeset
    |> filter_project(project_id)
    |> filter_assignee(current_user.id, assigned)
    |> filter_state(state)
    |> filter_date(date_from, date_to)
    |> sort_attributes(sort)
  end

  defp generate_info(old, new, name) do
    name <> " moved bug from state: " <> old.state <> " to: " <> new.state
  end

  defp filter_project(changeset, nil), do: changeset
  defp filter_project(changeset, project_id), do: changeset |> where([ser_tem], ser_tem.project_id == ^project_id)

  defp filter_assignee(changeset, user_id, sort) do
    case sort do
      "my" -> changeset |> where([ser_tem], ser_tem.user_id == ^user_id)
      "unassigned" -> changeset |> where([ser_tem], is_nil(ser_tem.user_id))
      _ -> changeset
    end
  end

  defp filter_state(changeset, state) do
    case state do
      st when is_binary(st) -> changeset |> where([ser_tem], ser_tem.state == ^state)
      _ -> changeset
    end
  end

  defp sort_attributes(changeset, sort) do
    case sort do
      "title" -> changeset |> order_by([ser_tem], ser_tem.title)
      "priority" -> changeset |> order_by([ser_tem], desc: ser_tem.priority)
      "last_time" -> changeset |> order_by([ser_tem], desc: ser_tem.last_time_seen_at)
      "occurrences" -> changeset |> order_by([ser_tem], desc: ser_tem.server_failure_count)
      _ -> changeset |> order_by([ser_tem], desc: ser_tem.last_time_seen_at)
    end
  end

  defp filter_date(changeset, "", ""), do: changeset
  defp filter_date(changeset, date_from, date_to) do
    import Errorio.ErrorioHelper, only: [parse_date: 1]
    changeset =
    if date_from do
      changeset |> where([ser_tem], ser_tem.last_time_seen_at >= ^parse_date(date_from))
    else
      changeset
    end
    changeset =
    if date_to do
      changeset |> where([ser_tem], ser_tem.last_time_seen_at <= ^parse_date(date_to))
    else
      changeset
    end
  end
end
