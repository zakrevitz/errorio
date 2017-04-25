defmodule Errorio.ProjectController do
  use Errorio.Web, :controller
  alias Errorio.Project

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, params, current_user, _claims) do
    page =
      Project
      |> preload(:server_failure_templates)
      |> Repo.paginate(params)

    render conn, :index,
      projects: page.entries,
      current_user: current_user,
      page: page
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    server_failure_template = find_resource(id) |> Repo.preload([:server_failures, :assignee])
    case server_failure_template do
      nil ->
        conn
        |> put_flash(:error, "Could not find server failure ID:#{id}.")
        |> redirect(to: server_failure_template_path(conn, :index))
      server_failure ->
        conn
        |> assign(:server_failure_template, server_failure)
        |> render("show.html", current_user: current_user)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end

  defp find_resource(id) do
    result = ServerFailureTemplate
    |> Repo.get(id)
    result
  end
end
