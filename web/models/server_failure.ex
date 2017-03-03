defmodule Errorio.ServerFailure do
  use Errorio.Web, :model

  schema "server_failures" do
    field :title, :string
    field :request, :string
    field :processed_by, :string
    field :exception, :string
    field :host, :string
    field :backtrace, :string
    field :server, :string
    field :params, :string
    belongs_to :server_failure_templates, Errorio.ServerFailureTemplate, foreign_key: :server_failure_template_id

    timestamps()
  end


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params])
    |> validate_required([:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params, :server_failure_template_id])
    |> validate_required([:title,:host, :backtrace, :server])
    |> update_template_counter(1)
  end

  defp update_template_counter(changeset, value) do
    changeset
    |> prepare_changes(fn prepared_changeset ->
      repo = prepared_changeset.repo
      template_id = prepared_changeset.changes.server_failure_template_id
      last_seen = Ecto.DateTime.utc |> Ecto.DateTime.to_erl |> NaiveDateTime.from_erl!

      from(p in Errorio.ServerFailureTemplate,
      where: p.id == ^template_id)
      |> repo.update_all(inc: [server_failure_count: value], set: [last_time_seen_at: last_seen])
      prepared_changeset
    end)
  end
end
