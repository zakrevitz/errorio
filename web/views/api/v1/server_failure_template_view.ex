defmodule Errorio.Api.V1.ServerFailureTemplateView do
  use Errorio.Web, :view

  def render("index.json", %{server_failure_templates: server_failure_templates}) do
    %{data: render_many(server_failure_templates, Errorio.Api.V1.ServerFailureTemplateView, "server_failure_template.json")}
  end

  def render("show.json", %{server_failure_template: server_failure_template}) do
    %{data: render_one(server_failure_template, Errorio.Api.V1.ServerFailureTemplateView, "server_failure_template.json")}
  end

  def render("server_failure.json", %{server_failure: server_failure}) do
    %{data: [%{"type": "server_failure", "id": server_failure.id}]}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
