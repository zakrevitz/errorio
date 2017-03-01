defmodule Errorio.ServerFailureController do
  use Errorio.Web, :controller
  alias Errorio.ServerFailure
  alias Errorio.ErrorioHelper
  alias Errorio.StateMachine

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params, current_user, _claims) do
    server_failures = Repo.all(ServerFailure)
    render(conn, "index.html", server_failures: server_failures, current_user: current_user)
  end

  def show(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Could not find server failure ID:#{id}.")
        |> redirect(to: server_failure_path(conn, :index))
      server_failure ->
        conn
        |> assign(:server_failure, server_failure)
        |> render("show.html", current_user: current_user)
    end
  end

  def migrate(conn, %{"event" => event, "server_failure_id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    case find_resource(id) do
      nil ->
        conn
        |> put_flash(:error, "Oops, something gone wrong")
        |> redirect(to: server_failure_path(conn, :index))
      server_failure ->
        result = StateMachine.migrate(String.to_atom(event), server_failure, Errorio.ServerFailure)
        case result do
          {:ok, server_failure} ->
            conn
            |> put_flash(:info, "Yep, we changed state ^_^")
            |> assign(:server_failure, server_failure)
            |> render("show.html", current_user: current_user)
          {:error, _reason} ->
            conn
            |> put_flash(:error, "Could not migrate. Error: #{ErrorioHelper.humanize_atom(_reason)}")
            |> redirect(to: server_failure_path(conn, :index))
        end
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end

  defp find_resource(id) do
    result = ServerFailure
    |> Repo.get(id)
    result
  end
end
