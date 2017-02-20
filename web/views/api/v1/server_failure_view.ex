defmodule Errorio.Api.V1.ServerFailureView do
  use Errorio.Web, :view

  def render("index.json", %{server_failures: server_failures}) do
    %{data: render_many(server_failures, Errorio.Api.V1.ServerFailureView, "server_failure.json")}
  end

  def render("show.json", %{server_failure: server_failure}) do
    %{data: render_one(server_failure, Errorio.Api.V1.ServerFailureView, "server_failure.json")}
  end

  def render("server_failure.json", %{server_failure: server_failure}) do
    %{id: server_failure.id,
      title: server_failure.title,
      request: server_failure.request,
      processed_by: server_failure.processed_by,
      exception: server_failure.exception,
      host: server_failure.host,
      backtrace: server_failure.backtrace,
      server: server_failure.server,
      params: server_failure.params,
      state: server_failure.state}
  end
end
