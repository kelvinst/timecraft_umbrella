defmodule Timecraft.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Timecraft.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Timecraft.PubSub}
      # Start a worker by calling: Timecraft.Worker.start_link(arg)
      # {Timecraft.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Timecraft.Supervisor)
  end
end
