defmodule Errorio.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Errorio.Web, :controller
      use Errorio.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      use Guardian.Phoenix.Controller

      alias Errorio.Repo
      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      import Ecto
      import Ecto.Query

      import Errorio.Router.Helpers
      import Errorio.Gettext
    end
  end

  def admin_controller do
    quote do
      use Phoenix.Controller, namespace: Errorio.Admin
      use Guardian.Phoenix.Controller, key: :admin

      alias Errorio.Repo
      alias Guardian.Plug.EnsureAuthenticated
      alias Guardian.Plug.EnsurePermissions

      import Ecto
      import Ecto.Schema
      import Ecto.Query, only: [from: 1, from: 2]

      import Errorio.Router.Helpers
      import Errorio.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Errorio.Router.Helpers
      import Errorio.ErrorHelpers
      import Errorio.Gettext
      import Errorio.ViewHelpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Errorio.Repo
      import Ecto
      import Ecto.Query
      import Errorio.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
