defmodule Simulations.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SimulationsWeb.Telemetry,
      Simulations.Repo,
      {DNSCluster, query: Application.get_env(:simulations, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Simulations.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Simulations.Finch},
      # Start a worker by calling: Simulations.Worker.start_link(arg)
      # {Simulations.Worker, arg},
      # Start to serve requests, typically the last entry
      SimulationsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Simulations.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SimulationsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
