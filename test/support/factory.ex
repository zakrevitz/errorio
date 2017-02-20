defmodule Errorio.Factory do
  use ExMachina.Ecto, repo: Errorio.Repo

  def server_failure_factory do
    %Errorio.ServerFailure{
      title: "NoMethodError",
      request: "GET </post/99999999999999>",
      processed_by: "controller#action",
      exception: "undefined '99999999999999' method for controller#action",
      host: "test-zone",
      backtrace: "/var/www/translationdeal.com/app/forms/social_registration_form.rb:44:in `initialize'
                  /var/www/translationdeal.com/app/controllers/auth/sessions_controller.rb:88:in `new'",
      server: "http://bestedudeal.com/",
      params: "{id: 99999999999999}",
      state: 0
    }
  end
end
