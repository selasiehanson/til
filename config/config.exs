# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :til,
  ecto_repos: [Til.Repo]

# Configures the endpoint
config :til, Til.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZoEnN+gi2cS4xH9nJgPqdoSHJerfK10aFPAJFUN4MlKF8pu1GQjrYHA3N4DwXTJu",
  render_errors: [view: Til.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Til.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "Til",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: to_string(Mix.env),
  serializer: Til.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
