defmodule Errorio.Admin.ServerFailureTemplateController do
  use Errorio.Web, :admin_controller

  alias Errorio.ServerFailureTemplate
  alias Errorio.StateMachine
  alias Errorio.ErrorioHelper

  plug Ueberauth, base_path: "/admin/users", providers: [:identity]
  plug EnsureAuthenticated, [key: :admin, handler: __MODULE__]

  def index(conn, params, current_user, _claims) do
    page =
      ServerFailureTemplate
      |> preload([:project, :assignee])
      |> Repo.paginate(params)
    render(conn, "index.html", server_failures: page.entries, current_user: current_user, page: page)
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Could not find server failure ID:#{id}.")
        |> redirect(to: admin_server_failure_template_path(conn, :index))
      server_failure ->
        server_failure = server_failure |> Repo.preload([[event_transition_logs: :responsible], :project, :assignee, :server_failures])
        conn
        |> assign(:server_failure_template, server_failure)
        |> render("show.html", current_user: current_user)
    end
  end

  def migrate(conn, %{"event" => event, "server_failure_template_id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Oops, something gone wrong")
        |> redirect(to: admin_server_failure_template_path(conn, :index))
      server_failure_template ->
        result = StateMachine.migrate(String.to_atom(event), server_failure_template, Errorio.ServerFailureTemplate)
        |> ServerFailureTemplate.log_transition(server_failure_template, current_user)
        case result do
          {:ok, _server_failure_template} ->
            conn
            |> put_flash(:info, "Yep, we changed state ^_^")
            |> redirect(to: admin_server_failure_template_path(conn, :index))
          {:error, reason} ->
            conn
            |> put_flash(:error, "Could not migrate. Error: #{ErrorioHelper.humanize_atom(reason)}")
            |> redirect(to: admin_server_failure_template_path(conn, :index))
        end
    end
  end

  def assign(conn, %{"server_failure_template" => params, "server_failure_template_id" => id}, _current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Oops, something gone wrong")
        |> redirect(to: admin_server_failure_template_path(conn, :index))
      server_failure_template ->
        result = server_failure_template
        |> ServerFailureTemplate.update_assignee(params["assignee_id"])
        case result do
          {:ok, server_failure_template} ->
            conn
            |> render("assign.json", server_failure_template: server_failure_template)
          {:error, reason} ->
            conn
            |> put_flash(:error, "Could not assign. Error: #{ErrorioHelper.humanize_atom(reason)}")
            |> redirect(to: admin_server_failure_template_path(conn, :index))
        end
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claims) do
    {id, _} = Integer.parse(id)
    result = ServerFailureTemplate
    |> Repo.get!(id)
    |> Repo.delete
    case result do
      {:ok, _server_failure} ->
        conn
        |> put_flash(:info, "Bug ID:#{id} successfully deleted!")
        |> redirect(to: admin_server_failure_template_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not delete. Error: #{ErrorioHelper.humanize_atom(reason)}")
        |> redirect(to: admin_server_failure_template_path(conn, :index))
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end

  defp find_resource(id) do
    ServerFailureTemplate
    |> Repo.get(id)
  end
end
