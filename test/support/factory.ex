defmodule Errorio.Factory do
  use ExMachina.Ecto, repo: Errorio.Repo
  use Errorio.JsonEncodeStrategy

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

  def server_failure_request_factory do
    %{
      "context" =>
      %{
        "action" => "show",
        "component" => "pages",
        "environment" => "development",
        "hostname" => "netfix",
        "language" => "ruby/2.2.1",
        "notifier" => %{
          "name" => "errorio-ruby",
          "url" => "https://github.com/zakrevitz/errorio_gem",
          "version" => "0.0.1"
        },
        "os" => "x86_64-linux",
        "rootDirectory" => "/home/alexandr/projects/netfix/glossessays.com",
        "site_name" => "http://glossessays.com/",
        "url" => "http://lvh.me:3000/%D1%84%D1%8B%D0%B2%D1%8F%D1%87%D1%81",
        "userAgent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/53.0.2785.143 Chrome/53.0.2785.143 Safari/537.36",
        "version" => "Rails/4.0.13"
      },
      "environment" => %{
        "headers" => %{
          "HTTP_ACCEPT" =>
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
          "HTTP_ACCEPT_ENCODING" => "gzip, deflate, sdch",
          "HTTP_ACCEPT_LANGUAGE" => "en-US,en;q=0.8",
          "HTTP_CONNECTION" => "keep-alive",
          "HTTP_COOKIE" => "page_update_16=5698fe13; page_update_13=5667e8e8; page_update_12=5763b996; page_update_7=58c14f83; page_update_8=5763b996; page_update_6=58ee1bce; page_update_11=5763b996; page_update_9=58ee4782; _ga=GA1.2.1360583700.1489751962; page_update_10=5763b996; LaVisitorId=7bkdn0cg6fwgxox888alwm6p5nsuo; LaSID=apgnld3asu37lpud4dyf9x82p1xno; _classyessay_com_session=d1REQ1pGejBKRk84eFNlZVlqbk5EV1dVVEp2SWFxQXpDZjVJUkN1N3djZkhmc0lGamRrVG4zKzZhd0ZPbVJWUFY1SUJGVDUwK0lidHJEV0FNa1FMSG5rcVdSdTdKYVdvREI5YnNPVTMwdFA4OXJmekY0dG4raldVMGdkUUE5R2xSMUE2bXJKWkwzTm9ONWp5emxjVVBHc0V1dUNTODZkSGRDK0hIN0FVdUEyeXlFaERkOURDNGFCN3k0dHJMNVpKZmE5UUhsSWczM0RPVGJ4REg2bDRPY3hnZ0Fzb2IwUjZyb3ZKNHJXaTl4QWEzNTFjckVXdzhWaFJCRGlyYnp2Z1hIOXMyZnZsTHkwRkVSVEZ5d05FdHc9PS0tYmF3NCtnWWdtQ3VFanhIUVNXVjR4Zz09--d66d25d5fb46a732a5251ce14d48b2ac2313d2d9",
          "HTTP_HOST" => "lvh.me:3000",
          "HTTP_UPGRADE_INSECURE_REQUESTS" => "1",
          "HTTP_USER_AGENT" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/53.0.2785.143 Chrome/53.0.2785.143 Safari/537.36",
          "HTTP_VERSION" => "HTTP/1.1"
        },
        "httpMethod" => "GET",
        "referer" => nil
      },
      "errors" => [
        %{
          "backtrace" => [
            %{
              "file" => "[GEM_ROOT]/bundler/gems/writers_cms_gem_2_0-efd78a126a79/app/controllers/pages_controller.rb",
              "function" => "find_structure",
              "line" => 38
            }, %{
              "file" => "[GEM_ROOT]/gems/activesupport-4.0.13/lib/active_support/callbacks.rb",
              "function" => "_run__3379642959712562482__process_action__callbacks",
              "line" => 447
            }, %{
              "file" => "[GEM_ROOT]/gems/activesupport-4.0.13/lib/active_support/callbacks.rb",
              "function" => "run_callbacks",
              "line" => 80
            }
          ],
          "message" => "Structure фывячс not found",
          "type" => "ActiveRecord::RecordNotFound"
        }
      ],
      "params" => %{
        "action" => "show",
        "controller" => "pages",
        "format" => "html",
        "id" => "фывячс"
      },
      "session" => %{}
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
