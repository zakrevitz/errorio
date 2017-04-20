defmodule Errorio.Project do
  use Errorio.Web, :model

  @api_key_length 21 # default api key length

  schema "projects" do
    field :name, :string
    field :template, :string
    field :api_key, :string

    has_many :server_failure_templates, Errorio.ServerFailureTemplate

    timestamps()
  end

  def changeset(struct, params = %{ "api_key" => "" } ) do
    params = Map.put(params, "api_key", generate_api_key())
    struct
    |> cast(params, [:name, :template, :api_key])
    |> validate_required([:name, :template, :api_key])
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :template, :api_key])
    |> validate_required([:name, :template, :api_key])
  end

  def create_changeset(project, params \\ %{}) do
    cast(project, params, [:name, :template, :api_key])
  end

  # TODO: use Ecto.Enum dep for this enum

  def templates do
    [
      "v1 sites": "v1",
      "v1-v2 sites": "v1-v2",
      "v2 sites": "v2",
      "v3 sites": "v3",
      "v4 sites": "v4",
      "Reviews sites (ORM)": "reviews",
      "Other": "other",
      "CRM": "crm",
      "Translation sites": "translation"
    ]
  end

  defp generate_api_key do
    # Generates random string api_key_length chars length
    :crypto.strong_rand_bytes(@api_key_length) |> Base.url_encode64 |> binary_part(0, @api_key_length)
  end
end
