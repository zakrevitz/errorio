defmodule Errorio.Project do
  use Errorio.Web, :model

  schema "projects" do
    field :name, :string
    field :template, :string
    field :api_key, :string

    has_many :server_failure_templates, Errorio.ServerFailureTemplate

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :template, :api_key])
    |> validate_required([:name, :template, :api_key])
  end
end
