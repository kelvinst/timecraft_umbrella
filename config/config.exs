# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :timecraft,
  ecto_repos: [Timecraft.Repo]

config :timecraft_web,
  ecto_repos: [Timecraft.Repo],
  generators: [context_app: :timecraft]

# Configures the endpoint
config :timecraft_web, TimecraftWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KlUxoz2N1uPdEEvSi9Idw4OLMmZp2mXKIVbvYbtmLk4E0KjjnjAj0KklX0KNur9G",
  render_errors: [view: TimecraftWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Timecraft.PubSub,
  live_view: [signing_salt: "HO6lN+0L"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
