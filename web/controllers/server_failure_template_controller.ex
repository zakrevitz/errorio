defmodule Errorio.ServerFailureTemplateController do
  use Errorio.Web, :controller
  alias Errorio.ServerFailureTemplate
  alias Errorio.ErrorioHelper
  alias Errorio.StateMachine

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params, current_user, _claims) do
    server_failures = Repo.all(ServerFailureTemplate)
    render(conn, "index.html", server_failures: server_failures, current_user: current_user)
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

  def migrate(conn, %{"event" => event, "server_failure_template_id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Oops, something gone wrong")
        |> redirect(to: server_failure_template_path(conn, :index))
      server_failure_template ->
        result = StateMachine.migrate(String.to_atom(event), server_failure_template, Errorio.ServerFailureTemplate)
        |> ServerFailureTemplate.assign(current_user)
        case result do
          {:ok, server_failure_template} ->
            conn
            |> put_flash(:info, "Yep, we changed state ^_^")
            |> redirect(to: server_failure_template_path(conn, :show, server_failure_template.id))
          {:error, _reason} ->
            conn
            |> put_flash(:error, "Could not migrate. Error: #{ErrorioHelper.humanize_atom(_reason)}")
            |> redirect(to: server_failure_template_path(conn, :index))
        end
    end
  end

  def assign(conn, %{"server_failure_template_id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Oops, something gone wrong")
        |> redirect(to: server_failure_template_path(conn, :index))
      server_failure_template ->
        result = server_failure_template
        |> ServerFailureTemplate.update_assignee(current_user.id)
        case result do
          {:ok, server_failure_template} ->
            conn
            |> put_flash(:info, "Not it is officially your problem")
            |> redirect(to: server_failure_template_path(conn, :show, server_failure_template.id))
          {:error, _reason} ->
            conn
            |> put_flash(:error, "Could not assign. Error: #{ErrorioHelper.humanize_atom(_reason)}")
            |> redirect(to: server_failure_template_path(conn, :index))
        end
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
