defmodule Errorio.ProjectController do
  use Errorio.Web, :controller
  alias Errorio.Project
  alias Errorio.ServerFailureTemplate

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params, current_user, _claims) do
    projects =
      Project
      |> preload(:server_failure_templates)
      |> Repo.all

    render conn, :index,
      projects: projects,
      current_user: current_user
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    project = find_resource(id)
    case project do
      nil ->
        conn
        |> put_flash(:error, "Could not find project ID:#{id}.")
        |> redirect(to: project_path(conn, :index))
      project ->
        stats = ServerFailureTemplate |> Ecto.Query.where(project_id: ^id) |> ServerFailureTemplate.statistics
        conn
        |> assign(:project, project)
        |> render("show.html", current_user: current_user, stats: stats)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end

  defp find_resource(id) do
    result = Project
    |> preload(:responsible)
    |> Repo.get(id)
    result
  end
end
