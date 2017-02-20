defmodule Errorio.ServerFailureController do
  use Errorio.Web, :controller
  alias Errorio.ServerFailure
  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, _params, current_user, _claims) do
    server_failures = Repo.all(ServerFailure)
    render(conn, "index.html", server_failures: server_failures, current_user: current_user)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end
end
