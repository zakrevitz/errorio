defmodule Errorio.Api.ServerFailure.Builder do
  alias Errorio.ServerFailure
  alias Errorio.ServerFailureTemplate
  alias Errorio.Repo

  def setup_server_failure(server_failure_params) do
    case Repo.transaction(fn ->
      case find_server_failure_template(server_failure_params) do
        {:ok, template} ->
            create_server_failure(template, server_failure_params)
        {:error, reason} ->
          Repo.rollback(reason)
      end
    end) do
      {:ok, server_failure} ->
        server_failure
      {:error, reason} -> {:error, reason}
    end
  end


  defp create_server_failure(template, server_failure_params) do
    template
    |> Ecto.build_assoc(:server_failures)
    |> ServerFailure.create_changeset(server_failure_params)
    |> Repo.insert
  end

  defp create_server_failure_template(hash, server_failure_params) do
    params = server_failure_params |> Map.put("md5_hash", hash)
    ServerFailureTemplate.create_changeset(%ServerFailureTemplate{}, params)
    |> Repo.insert
  end

  defp generate_md5_hash(server_failure_params) do
    hash_string = server_failure_params["title"]
    <> server_failure_params["host"]
    <> server_failure_params["server"]
    <> fetch_filename_from_backtrace(server_failure_params["backtrace"])
    :crypto.hash(:md5, hash_string) |> Base.encode16(case: :lower)
  end

  defp find_server_failure_template(server_failure_params) do
    hash = generate_md5_hash(server_failure_params)
    case Repo.get_by(ServerFailureTemplate, md5_hash: hash) do
      nil ->
        create_server_failure_template(hash, server_failure_params)
      template ->
        {:ok, template}
    end
  end

  defp fetch_filename_from_backtrace(backtrace \\ "") do
    [head|_] = String.split(backtrace, "\n", parts: 2)
    String.split(head, "/")
    |> Enum.at(-1)
  end
end
