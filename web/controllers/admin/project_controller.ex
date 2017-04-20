defmodule Errorio.Admin.ProjectController do
  use Errorio.Web, :admin_controller

  alias Errorio.Project
  alias Errorio.ErrorioHelper

  plug Ueberauth, base_path: "/admin/users", providers: [:identity]
  plug EnsureAuthenticated, [key: :admin, handler: __MODULE__]

  def index(conn, _params, current_user, _claims) do
    projects = Repo.all(Project)
    render(conn, "index.html", projects: projects, current_user: current_user)
  end

  def new(conn, params , current_user, _claims) do
    changeset = Project.create_changeset(%Project{})
    render conn, "new.html", current_user: current_user, changeset: changeset, templates: Project.templates
  end

  def create(conn, %{"project" => project_params}, current_user, _claims) do
    result = Project.changeset(%Project{}, project_params) |> Repo.insert
    case result do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: admin_project_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:templates, Project.templates)
        |> render("new.html", changeset: changeset, current_user: current_user)
    end
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Could not find server failure ID:#{id}.")
        |> redirect to: admin_project_path(conn, :index)
      project ->
        conn
        |> assign(:project, project)
        |> render("show.html", current_user: current_user)
    end
  end

  def delete(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    result = Project
    |> Repo.get!(id)
    |> Repo.delete
    case result do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project ID:#{id} successfully deleted!")
        |> redirect to: admin_project_path(conn, :index)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not delete. Error: #{ErrorioHelper.humanize_atom(_reason)}")
        |> redirect to: admin_project_path(conn, :index)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end

  defp find_resource(id) do
    result = Project
    |> Repo.get(id)

    result
  end
end
