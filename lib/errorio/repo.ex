defmodule Errorio.Repo do
  use Ecto.Repo, otp_app: :errorio
  use Scrivener, page_size: 10
end
