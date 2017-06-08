defmodule Errorio.Repo do
  use Ecto.Repo, otp_app: :errorio
  use Kerosene, per_page: 50
end
