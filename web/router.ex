defmodule Errorio.Router do
  use Errorio.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
    plug Guardian.Plug.LoadResource, key: :admin
  end

  pipeline :impersonation_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", Errorio do
    pipe_through [:browser, :browser_auth, :impersonation_browser_auth] # Use the default browser stack
    delete "/logout", AuthController, :logout

    get "/", ServerFailureTemplateController, :index
    resources "/server_failures", ServerFailureTemplateController do
      get "/migrate", ServerFailureTemplateController, :migrate, as: :migrate
      get "/assign", ServerFailureTemplateController, :assign, as: :assign
    end
    resources "/users", UserController
  end

  scope "/auth", Errorio do
    pipe_through [:browser, :browser_auth] # Use the default browser stack

    get "/:identity", AuthController, :login
    get "/:identity/callback", AuthController, :callback
    post "/:identity/callback", AuthController, :callback
  end

  scope "/admin", Errorio.Admin, as: :admin do
    pipe_through [:browser, :admin_browser_auth] # Use the default browser stack

    get "/login", SessionController, :new, as: :login
    get "/login/:identity", SessionController, :new
    post "/auth/:identity/callback", SessionController, :callback
    get "/logout", SessionController, :logout
    delete "/logout", SessionController, :logout, as: :logout
    post "/impersonate/:user_id", SessionController, :impersonate, as: :impersonation
    delete "/impersonate", SessionController, :stop_impersonating

    resources "/users", UserController
    resources "/server_failures", ServerFailureTemplateController do
      get "/migrate", ServerFailureTemplateController, :migrate, as: :migrate
    end
    resources "/projects", ProjectController
    post "/users/:identity/callback", UserController, :callback
  end

  scope "/api", Errorio.Api, as: :api do
    # pipe_through [:api, :api_auth]
    pipe_through [:api]
    scope "/v1", V1, as: :v1 do
      resources "/server_failures", ServerFailureTemplateController
    end
  end
end
