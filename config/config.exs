# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :calc_sample,
  ecto_repos: [CalcSample.Repo],
  generators: [timestamp_type: :utc_datetime]

config :calc_sample, :ash_domains, [
  CalcSample.Calculations
]

# Configures the endpoint
config :calc_sample, CalcSampleWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: CalcSampleWeb.ErrorHTML, json: CalcSampleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CalcSample.PubSub,
  live_view: [signing_salt: "CFHOYl5A"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  calc_sample: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  calc_sample: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
