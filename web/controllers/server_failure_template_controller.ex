defmodule Errorio.ServerFailureTemplateController do
  use Errorio.Web, :controller
  alias Errorio.ServerFailureTemplate
  alias Errorio.ErrorioHelper
  alias Errorio.StateMachine
  # alias Errorio.Statistic.ServerFailure, as: ServerFailureStats
  alias Errorio.ServerFailure, as: ServerFailure

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, params, current_user, _claims) do
    project_id = Map.get(params, "project_id", nil)
    assigned = Map.get(params, "assigned", nil)
    state = Map.get(params, "state", nil)
    sort = Map.get(params, "sort", nil)
    page =
      ServerFailureTemplate
      |> fitler_project(project_id)
      |> fitler_sort(current_user.id, assigned)
      |> fitler_sort(sort)
      |> fitler_sort_by_state(state)
      |> preload(:assignee)
      |> Repo.paginate(params)

    render conn, :index,
      server_failures: page.entries,
      current_user: current_user,
      page: page
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    server_failure_template = find_resource(id) |> Repo.preload([:assignee])
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
        |> ServerFailureTemplate.update_assignee(current_user.id)
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

  defp fitler_project(changeset, nil), do: changeset
  defp fitler_project(changeset, project_id), do: changeset |> where([ser_tem], ser_tem.project_id == ^project_id)

  defp fitler_sort(changeset, sort) do
    case sort do
      "title" -> changeset |> order_by([ser_tem], ser_tem.title)
      "priority" -> changeset |> order_by([ser_tem], desc: ser_tem.priority)
      "last_time" -> changeset |> order_by([ser_tem], ser_tem.last_time_seen_at)
      "occurrences" -> changeset |> order_by([ser_tem], desc: ser_tem.server_failure_count)
      _ -> changeset
    end
  end

  defp fitler_sort(changeset, user_id, sort) do
    case sort do
      "my" -> changeset |> where([ser_tem], ser_tem.user_id == ^user_id)
      "unassigned" -> changeset |> where([ser_tem], is_nil(ser_tem.user_id))
      _ -> changeset
    end
  end

  defp fitler_sort_by_state(changeset, state) do
    case state do
      st when is_binary(st) -> changeset |> where([ser_tem], ser_tem.state == ^state)
      _ -> changeset
    end
  end
end
