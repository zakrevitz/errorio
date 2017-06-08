defmodule Errorio.ServerFailureTemplateView do
  use Errorio.Web, :view
  import Kerosene.HTML
  alias Errorio.ServerFailureTemplate

  def render("ok.json", %{}) do
    %{"ok": "ok"}
  end
end
