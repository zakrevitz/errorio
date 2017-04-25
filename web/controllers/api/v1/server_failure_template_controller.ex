defmodule Errorio.Api.V1.ServerFailureTemplateController do
  use Errorio.Web, :api_controller

  alias Errorio.Project

  def create(conn, %{"server_failure" => server_failure_params, "token" => project_key}) do
    case find_project(project_key) do
      {:ok, project} -> case Errorio.Api.ServerFailure.Builder.setup_server_failure(server_failure_params, project) do
          {:ok, server_failure} ->
            conn
            |> put_status(:created)
            |> render("server_failure.json", server_failure: server_failure)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Errorio.ChangesetView, "error.json", changeset: changeset)
        end
      {:error, _reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", error: "Project not founded")
    end
  end

  defp find_project(key) do
    case Repo.get_by(Project, api_key: key) do
      nil -> {:error, "Project Not Founded"}
      project -> {:ok, project}
    end
  end
end
