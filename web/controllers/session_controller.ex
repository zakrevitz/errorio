defmodule Errorio.SessionController do
  # use Errorio.Web, :controller

  # alias Errorio.User
  # alias Errorio.UserQuery

  # plug :scrub_params, "user" when action in [:create]

  # def create(conn, params = %{}) do
  #   conn
  #   |> put_flash(:info, "Logged in.")
  #   |> Guardian.Plug.sign_in(verified_user) # verify your logged in resource
  #   |> redirect(to: user_path(conn, :index))
  # end

  # def delete(conn, _params) do
  #   Guardian.Plug.sign_out(conn)
  #   |> put_flash(:info, "Logged out successfully.")
  #   |> redirect(to: "/")
  # end
end
