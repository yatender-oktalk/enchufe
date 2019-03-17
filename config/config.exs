# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :enchufe, EnchufeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3ubyh6x0giTpYEw8PhCf8MCjZ1D/7DoGZ4Z/VBwE+ffjPUzY7IngYWhg1j5ualgO",
  render_errors: [view: EnchufeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Enchufe.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
