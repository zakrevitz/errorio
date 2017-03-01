defmodule Errorio.Admin.ServerFailureController do
  use Errorio.Web, :admin_controller

  alias Errorio.ServerFailure
  alias Errorio.User
  alias Errorio.ErrorioHelper

  plug Ueberauth, base_path: "/admin/users", providers: [:identity]
  plug EnsureAuthenticated, [key: :admin, handler: __MODULE__]

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
        |> redirect to: admin_server_failure_path(conn, :index)
      server_failure ->
        conn
        |> assign(:server_failure, server_failure)
        |> render("show.html", current_user: current_user)
    end
  end

  def delete(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    result = ServerFailure
    |> Repo.get!(id)
    |> Repo.delete
    case result do
      {:ok, server_failure} ->
        conn
        |> put_flash(:info, "Bug ID:#{id} successfully deleted!")
        |> redirect to: admin_server_failure_path(conn, :index)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not delete. Error: #{ErrorioHelper.humanize_atom(_reason)}")
        |> redirect to: admin_server_failure_path(conn, :index)
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