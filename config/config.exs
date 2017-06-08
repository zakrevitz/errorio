# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :errorio,
  ecto_repos: [Errorio.Repo]

# Configures the endpoint
config :errorio, Errorio.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "We8tHT8XJS3lk1MbEjdj8S/9iJ/ej6sNkHxrcn7xOV9hIwS9SI3UWIxTeKh23Lgg",
  render_errors: [view: Errorio.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Errorio.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  level: :debug,
  truncate: :infinity

config :guardian, Guardian,
  issuer: "Errorio.#{Mix.env}",
  ttl: {14, :days},
  verify_issuer: true,
  serializer: Errorio.GuardianSerializer,
  secret_key: "NP6rasZZRaMvG2ziYVRGS97/kakBUURWc74JEWIQpjzNPWhC1hoGh4BaoztE6fVQ",
  hooks: GuardianDb,
  permissions: %{
    default: [
      :read_profile,
      :write_profile,
      :read_token,
      :revoke_token,
    ],
  }

config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]},
  ]

config :guardian_db, GuardianDb,
  repo: Errorio.Repo,
  sweep_interval: 60 # 60 minutes

# Configure templates
config :phoenix, :template_engines,
    slim: PhoenixSlime.Engine,
    slime: PhoenixSlime.Engine

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
