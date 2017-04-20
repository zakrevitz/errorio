defmodule Errorio.Api.ServerFailure.Builder do
  alias Errorio.ServerFailure
  alias Errorio.ServerFailureTemplate
  alias Errorio.Repo
  alias Errorio.Api.Structs.Failure, as: FailureStruct
  alias Errorio.Api.Structs.Template, as: TemplateStruct
  require Logger

  def setup_server_failure(server_failure_params, project) do
    parsed_params = Poison.Parser.parse!(server_failure_params) # JSON version
    # parsed_params = (server_failure_params) # Elixir.Map version
    {failure_struct, template_struct} = create_structs(parsed_params, project.id)
    case Repo.transaction(fn ->
      case find_server_failure_template(template_struct) do
        {:ok, template} ->
            create_server_failure(template, failure_struct)
        {:error, reason} ->
          Repo.rollback(reason)
      end
    end) do
      {:ok, server_failure} ->
        server_failure
      {:error, reason} -> {:error, reason}
    end
  end

  defp create_structs(%{}=params, project_id) do
    failure_struct = create_failure_struct(params)
    template_struct = Map.merge(%TemplateStruct{}, Map.take(failure_struct, [:title, :processed_by]))

    template_struct = %{template_struct | md5_hash: generate_md5_hash(failure_struct)}
    template_struct = %{template_struct | project_id: project_id}

    {failure_struct, template_struct}
  end

  defp create_failure_struct(%{}=params) do
    FailureStruct.new(params)
  end

  defp create_server_failure(template, failure_struct) do
    template
    |> Ecto.build_assoc(:server_failures)
    |> ServerFailure.create_changeset(Map.from_struct(failure_struct))
    |> Repo.insert
  end

  defp create_server_failure_template(template_struct) do
    ServerFailureTemplate.create_changeset(%ServerFailureTemplate{}, Map.from_struct(template_struct))
    |> Repo.insert
  end

  defp find_server_failure_template(template_struct) do
    # hash = generate_md5_hash(server_failure_params)
    case Repo.get_by(ServerFailureTemplate, md5_hash: template_struct.md5_hash) do
      nil ->
        create_server_failure_template(template_struct)
      template ->
        {:ok, template}
    end
  end

  defp generate_md5_hash(failure_struct) do
    # hash_string = if is_map(server_failure_params["errors"]), do: server_failure_params["errors"]["type"], else: "StandartError"
    # <> if is_map(server_failure_params["context"]), do: server_failure_params["context"]["hostname"], else: "undefined_host"
    # <> if is_map(server_failure_params["context"]), do: server_failure_params["context"]["site_name"], else: "undefined_site_name"
    # <> fetch_filename_from_backtrace(server_failure_params["errors"])
    hash_string = failure_struct.title <> failure_struct.host <> failure_struct.server <> fetch_filename_from_backtrace(failure_struct.backtrace) <> failure_struct.exception
    :crypto.hash(:md5, hash_string) |> Base.encode16(case: :lower)
  end

  defp fetch_filename_from_backtrace(error_info \\ %{}) do
    first_line = Enum.at(error_info, 0)
    if Map.has_key?(first_line, "file") do
      first_line["file"] <> first_line["function"]
    else
      ""
    end
    # [head|_] = String.split(backtrace, "\n", parts: 2)
    # String.split(head, "/")
    # |> Enum.at(-1)
  end
end
