defmodule Errorio.AuthControllerTest do
  use Errorio.ConnCase

  import Errorio.Factory

  alias Errorio.Repo
  alias Errorio.User
  alias Errorio.GuardianToken

  setup do
    user_auth = insert(:user) |> with_authorization
    admin_auth = insert(:user) |> User.make_admin! |> with_authorization

    {:ok, %{
        user: user_auth.user,
        admin: admin_auth.user,
        admin_auth: admin_auth,
        user_auth: user_auth,
      }
    }
  end

  test "DELETE /logout logs out the user and admin", context do
    build_conn = guardian_login(context.user, :token)
      |> guardian_login(context.admin, :token, key: :admin)
      |> get("/") # This get loads the info out of the session and puts it into the connection
    assert Guardian.Plug.current_resource(build_conn).id == context.user.id

    {:ok, user_claims} = Guardian.Plug.claims(build_conn)
    user_jti = Map.get(user_claims, "jti")
    refute Repo.get_by!(GuardianToken, jti: user_jti) == nil

    # Lets visit an admin path so that we can get the admin user loaded up
    build_conn = get build_conn, admin_user_path(build_conn, :index)
    assert Guardian.Plug.current_resource(build_conn, :admin).id == context.admin.id

    {:ok, admin_claims} = Guardian.Plug.claims(build_conn, :admin)
    admin_jti = Map.get(admin_claims, "jti")
    refute Repo.get_by!(GuardianToken, jti: admin_jti) == nil

    # now lets logout from the main logout and make sure they're both clear
    build_conn = delete recycle(build_conn), "/logout"

    assert Guardian.Plug.current_resource(build_conn) == nil
    assert Guardian.Plug.current_resource(build_conn, :admin) == nil

    assert Repo.get_by(GuardianToken, jti: user_jti) == nil
    assert Repo.get_by(GuardianToken, jti: admin_jti) == nil
  end
end
