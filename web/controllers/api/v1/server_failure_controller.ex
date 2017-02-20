defmodule Errorio.Api.V1.ServerFailureController do
  use Errorio.Web, :controller

  alias Errorio.ServerFailure

  def index(conn, _params) do
    server_failures = Repo.all(ServerFailure)
    render(conn, "index.json", server_failures: server_failures)
  end

  def create(conn, %{"server_failure" => server_failure_params}) do
    changeset = ServerFailure.changeset(%ServerFailure{}, server_failure_params)

    case Repo.insert(changeset) do
      {:ok, server_failure} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_server_failure_path(conn, :show, server_failure))
        |> render("show.json", server_failure: server_failure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Errorio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    server_failure = Repo.get!(ServerFailure, id)
    render(conn, "show.json", server_failure: server_failure)
  end

  def update(conn, %{"id" => id, "server_failure" => server_failure_params}) do
    server_failure = Repo.get!(ServerFailure, id)
    changeset = ServerFailure.changeset(server_failure, server_failure_params)

    case Repo.update(changeset) do
      {:ok, server_failure} ->
        render(conn, "show.json", server_failure: server_failure)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Errorio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    server_failure = Repo.get!(ServerFailure, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(server_failure)

    send_resp(conn, :no_content, "")
  end
end
