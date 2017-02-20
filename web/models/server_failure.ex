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
    field :state, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params, :state])
    |> validate_required([:title, :request, :processed_by, :exception, :host, :backtrace, :server, :params, :state])
  end
end
