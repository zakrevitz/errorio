defmodule Errorio.DashboardController do
  use Errorio.Web, :controller

  alias Errorio.ServerFailureTemplate

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"


  def index(conn, _params, current_user, _claims) do
    stats = ServerFailureTemplate |> ServerFailureTemplate.statistics
    render conn, :index, current_user: current_user, stats: stats
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end
end
