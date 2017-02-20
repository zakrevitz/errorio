defmodule Errorio.UserController do
  use Errorio.Web, :controller

  alias Errorio.Repo
  alias Errorio.User
  alias Errorio.Authorization

  def new(conn, params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end
end
