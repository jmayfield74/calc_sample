defmodule CalcSample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CalcSampleWeb.Telemetry,
      CalcSample.Repo,
      {DNSCluster, query: Application.get_env(:calc_sample, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CalcSample.PubSub},
      # Start a worker by calling: CalcSample.Worker.start_link(arg)
      # {CalcSample.Worker, arg},
      # Start to serve requests, typically the last entry
      CalcSampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CalcSample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CalcSampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
