defmodule Errorio.Api.V1.ServerFailureTemplateController do
  use Errorio.Web, :api_controller

  alias Errorio.ServerFailureTemplate

  def index(conn, _params) do
    server_failure_templates = Repo.all(ServerFailureTemplate)
    render(conn, "index.json", server_failure_templates: server_failure_templates)
  end

  def create(conn, %{"server_failure" => server_failure_params}) do
    case Errorio.Api.ServerFailure.Builder.setup_server_failure(server_failure_params) do
      {:ok, server_failure} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_server_failure_template_path(conn, :show, server_failure))
        |> render("show.json", server_failure_template: server_failure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Errorio.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
