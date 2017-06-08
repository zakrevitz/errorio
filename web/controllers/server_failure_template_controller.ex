defmodule Errorio.ServerFailureTemplateController do
  use Errorio.Web, :controller
  alias Errorio.ServerFailureTemplate
  alias Errorio.ErrorioHelper
  alias Errorio.StateMachine
  # alias Errorio.Statistic.ServerFailure, as: ServerFailureStats
  alias Errorio.ServerFailure, as: ServerFailure
  alias Errorio.Project

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, params, current_user, _claims) do
    {server_failures, kerosene} =
      ServerFailureTemplate
      |> ServerFailureTemplate.filter(params, current_user)
      |> preload(:assignee)
      |> Repo.paginate(params)

    project = find_project(params)

    render conn, :index,
      server_failures: server_failures,
      current_user: current_user,
      kerosene: kerosene,
      project: project
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    server_failure_template = find_resource(id) |> Repo.preload([[event_transition_logs: :responsible], :assignee, :project])
    server_failure_info = find_server_failure_info(id)
    case server_failure_template do
      nil ->
        conn
        |> put_flash(:error, "Could not find server failure ID:#{id}.")
        |> redirect(to: server_failure_template_path(conn, :index))
      server_failure ->
        conn
        |> assign(:server_failure_template, server_failure)
        |> assign(:server_failure_info, server_failure_info)
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
        |> ServerFailureTemplate.log_transition(server_failure_template, current_user)
        case result do
          {:ok, server_failure_template} ->
            conn
            |> put_flash(:info, "Yep, we changed state ^_^")
            |> redirect(to: server_failure_template_path(conn, :show, server_failure_template.id))
          {:error, reason} ->
            conn
            |> put_flash(:error, "Could not migrate. Error: #{ErrorioHelper.humanize_atom(reason)}")
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
        |> ServerFailureTemplate.update_assignee(current_user.id, current_user)
        case result do
          {:ok, server_failure_template} ->
            conn
            |> put_flash(:info, "Not it is officially your problem")
            |> redirect(to: server_failure_template_path(conn, :show, server_failure_template.id))
          {:error, reason} ->
            conn
            |> put_flash(:error, "Could not assign. Error: #{ErrorioHelper.humanize_atom(reason)}")
            |> redirect(to: server_failure_template_path(conn, :index))
        end
    end
  end

  def update(conn, %{"server_failure_template" => params, "id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Oops, something gone wrong")
        |> redirect(to: server_failure_template_path(conn, :index))
      server_failure_template ->
        changeset = server_failure_template
        |> ServerFailureTemplate.changeset(params)
        result = changeset |> Errorio.Repo.update
        case result do
          {:ok, server_failure_template} ->
            IO.puts inspect(changeset)
            if changeset.changes |> Map.has_key?(:priority) do
              ServerFailureTemplate.log_transition(result, changeset, current_user, :priority)
            end
            conn
            |> render("ok.json", server_failure_template: server_failure_template)
          {:error, reason} ->
            conn
            |> put_flash(:error, "Could not assign. Error: #{ErrorioHelper.humanize_atom(reason)}")
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

  defp find_server_failure_info(id) do
      ServerFailure
      |> where([sf], sf.server_failure_template_id == ^id)
      |> order_by(desc: :updated_at)
      |> limit(1)
      |> Repo.one
  end

  defp find_project(params) do
    case Map.has_key?(params, "project_id") do
      true -> Project |> Repo.get(Map.get(params, "project_id"))
      _ -> nil
    end
  end
end
