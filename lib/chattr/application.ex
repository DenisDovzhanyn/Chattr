defmodule Chattr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    redix_config = Application.get_env(:chattr, ChattrWeb.Redix)
    children = [
      ChattrWeb.Telemetry,
      Chattr.Repo,
      {DNSCluster, query: Application.get_env(:chattr, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Chattr.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Chattr.Finch},
      {Redix, host: redix_config[:host], port: redix_config[:port], password: redix_config[:password], name: :redix},
      # Start a worker by calling: Chattr.Worker.start_link(arg)
      # {Chattr.Worker, arg},
      # Start to serve requests, typically the last entry
      ChattrWeb.Endpoint,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chattr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChattrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
