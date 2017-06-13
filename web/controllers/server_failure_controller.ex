defmodule Errorio.ServerFailureController do
  use Errorio.Web, :controller
  alias Errorio.ErrorioHelper
  alias Errorio.ServerFailure

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__, typ: "access"

  def index(conn, params, current_user, _claims) do
    server_failure_template_id = Map.get(params, "server_failure_template_id")
    {server_failures, kerosene} =
      ServerFailure
      |> where([sf], sf.server_failure_template_id == ^server_failure_template_id)
      |> order_by([sf], desc: sf.inserted_at)
      |> Repo.paginate(params)

    render conn, :index,
      server_failures: server_failures,
      kerosene: kerosene
  end

  def charts(conn, params, _current_user, _claims) do
    project_id = Map.get(params, "project_id", [])
    series = Errorio.Statistic.ServerFailure.chart(project_id)
    render conn, :charts,
      series: series
  end


  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: auth_path(conn, :login, :identity))
  end
end
