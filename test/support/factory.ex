defmodule Errorio.Factory do
  use ExMachina.Ecto, repo: Errorio.Repo

  alias Errorio.User
  alias Errorio.Authorization
  alias Errorio.GuardianToken
  alias Errorio.Project
  alias Errorio.ServerFailure
  alias Errorio.ServerFailureTemplate


  def project_factory do
    %Project{
      name: "Affiliate Program",
      template: "other",
      api_key: :crypto.strong_rand_bytes(21) |> Base.url_encode64 |> binary_part(0, 21)
    }
  end

  def server_failure_template_factory do
    %ServerFailureTemplate{
      md5_hash: :crypto.strong_rand_bytes(21) |> Base.url_encode64 |> binary_part(0, 21),
      project: build(:project),
      title: "NoMethodError",
      processed_by: "controller#action"
    }
  end

  def server_failure_factory do
    %ServerFailure{
      title: "NoMethodError",
      request: "GET </post/99999999999999>",
      processed_by: "controller#action",
      exception: "undefined '99999999999999' method for controller#action",
      host: "test-zone",
      server: "http://bestedudeal.com/",
      server_failure_templates: build(:server_failure_template),
      params: %{"id" => 99999999999999},
      backtrace: [%{"file": "[GEM_ROOT]/gems/aasm-4.11.0/lib/aasm/aasm.rb", "line": 191, "function": "aasm_failed"},%{"file": "[GEM_ROOT]/gems/aasm-4.11.0/lib/aasm/aasm.rb", "line": 125, "function": "aasm_fire_event"}],
      session: %{},
      headers: %{"HTTP_HOST": "bestedudeal.com"},
      context: %{"os": "x86_64-linux"}
    }
  end

  def user_factory do
    %User{
      name: "Bob Belcher",
      email: sequence(:email, &"email-#{&1}@example.com"),
    }
  end

  def guardian_token_factory do
    %GuardianToken{
      jti: sequence(:jti, &"jti-#{&1}"),
    }
  end

  def authorization_factory do
    %Authorization{
      uid: sequence(:uid, &"uid-#{&1}"),
      user: build(:user),
      provider: "identity",
      token: Comeonin.Bcrypt.hashpwsalt("sekrit")
    }
  end

  def with_authorization(user, opts \\ []) do
    opts = opts ++ [user: user, uid: user.email]
    insert(:authorization, opts)
  end
end
