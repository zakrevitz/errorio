defmodule Errorio.DashboardController do
  use Errorio.Web, :controller

  alias Errorio.Repo
  alias Errorio.ServerFailureTemplate
  alias Errorio.Authorization

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"


  def index(conn, params, current_user, _claims) do
    stats = ServerFailureTemplate |> ServerFailureTemplate.statistics
    render conn, :index, current_user: current_user, stats: stats
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end
end
