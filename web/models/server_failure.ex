defmodule Errorio.ServerFailure do
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

  schema "server_failures" do
    field :title, :string
    field :request, :string
    field :processed_by, :string
    field :exception, :string
    field :host, :string
    field :backtrace, :string
    field :server, :string
    field :params, :string
    field :state, :string, default: "to_do"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params, :state])
    |> validate_required([:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params, :state])
    |> update_parent_counter(1)
  end

  defp update_parent_counter(changeset, value) do
    changeset
    |> prepare_changes(fn prepared_changeset ->
      repo = prepared_changeset.repo
      template_id = prepared_changeset.server_failure_template_id

      from(p in Errorio.ServerFailureTemplate,
      where: p.id == ^template_id)
      |> repo.update_all(inc: [server_failure_count: value])
      prepared_changeset
    end)
  end
end
