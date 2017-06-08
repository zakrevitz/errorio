defmodule Errorio.ServerFailureView do
  use Errorio.Web, :view
  import Kerosene.JSON
  alias Errorio.ErrorioHelper

  def render("index.json", %{server_failures: server_failures, kerosene: kerosene, conn: conn}) do
    %{data: render_many(server_failures, Errorio.ServerFailureView, "server_failure.json"),
      pagination: paginate(conn, kerosene)}
  end

  def render("server_failure.json", %{server_failure: server_failure}) do
    %{
      id: server_failure.id,
      title: server_failure.title,
      host: server_failure.host,
      server: server_failure.server,
      inserted_at: ErrorioHelper.format_date(server_failure.inserted_at),
      inserted_at_relative: ErrorioHelper.format_date_relative(server_failure.inserted_at)
    }
  end
end
