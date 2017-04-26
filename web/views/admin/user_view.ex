defmodule Errorio.Admin.UserView do
  use Errorio.Web, :view

  def render("index.json", %{users: users, current_user: _current_user}) do
    render_many(users, Errorio.Admin.UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{"#{user.id}" => user.name}
  end
end
