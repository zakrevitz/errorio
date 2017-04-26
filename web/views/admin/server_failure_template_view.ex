defmodule Errorio.Admin.ServerFailureTemplateView do
  use Errorio.Web, :view
  import Scrivener.HTML
  alias Errorio.ServerFailureTemplate

  def render("assign.json", %{}) do
    %{"ok": "ok"}
  end
end
