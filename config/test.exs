use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :errorio, Errorio.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :errorio, Errorio.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "developer",
  password: "1234",
  database: "errorio_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
