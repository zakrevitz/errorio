defmodule Errorio.Admin.UserController do
  use Errorio.Web, :admin_controller

  alias Errorio.User
  alias Errorio.UserFromAuth
  alias Errorio.ErrorioHelper

  plug Ueberauth, base_path: "/admin/users", providers: [:identity]

  # Make sure that we have a valid token in the :admin area of the session
  # We've aliased Guardian.Plug.EnsureAuthenticated in our Errorio.Web.admin_controller macro
  # plug EnsureAuthenticated, handler: __MODULE__, key: :admin
  plug EnsureAuthenticated, [key: :admin, handler: __MODULE__]

  def index(conn, _params, current_user, _claims) do
    users = Repo.all(User)
    render conn, :index, users: users, current_user: current_user
  end

  def new(conn, _params, current_user, _claims) do
    render conn, "new.html", current_user: current_user
  end

  def edit(conn, %{"id" => id}, current_user, _claims) do
    {id, _} = Integer.parse(id)
    conn
    |> assign(:user, Repo.get(User, id))
    |> render("edit.html", current_user: current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
    case UserFromAuth.admin_insert_new_user(auth, Repo) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User successfully created!")
        |> redirect(to: admin_user_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not create. Error: #{ErrorioHelper.humanize_atom(reason)}")
        |> render("new.html", current_user: current_user)
    end
  end

  # TODO: Make selected user as admin.
  # def make_admin(conn, %{"id": id}, current_user, _claims) do
  #   Repo.get(User, id) |> User.make_admin!
  #   put_flash(:info, "User successfully updated!")
  # end

  def update(conn, %{"id" => id, "user" => user_params, "auth" => auth_params}, current_user, _claims) do
    user = User
    |> Repo.get!(id)
    |> Repo.preload(:authorizations)
    case UserFromAuth.admin_update_user(user, user_params, auth_params, Repo) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "User updated successfully!")
        |> redirect(to: admin_user_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not update. Error: #{ErrorioHelper.humanize_atom(reason)}")
        |> render("edit.html", current_user: current_user, user: user)
    end
  end

  def delete(conn, %{"id" => id}, _current_user, _claims) do
    {id, _} = Integer.parse(id)
    result = User
    |> Repo.get!(id)
    |> Repo.delete
    case result do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User ID:#{id} (#{user.email}) successfully deleted!")
        |> redirect(to: admin_user_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Could not delete. Error: #{ErrorioHelper.humanize_atom(reason)}")
        |> redirect(to: admin_user_path(conn, :index))
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Admin authentication required")
    |> redirect(to: admin_login_path(conn, :new))
  end
end
