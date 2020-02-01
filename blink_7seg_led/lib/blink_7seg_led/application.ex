defmodule Blink7segLed.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blink7segLed.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: Blink7segLed.Worker.start_link(arg)
        # {Blink7segLed.Worker, arg},
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: Blink7segLed.Worker.start_link(arg)
      # {Blink7segLed.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: Blink7segLed.Worker.start_link(arg)
      # {Blink7segLed.Worker, arg},
      {BlinkLed.Worker, []},
      {Blink7segLed.Worker, []},
    ]
  end

  def target() do
    Application.get_env(:blink_7seg_led, :target)
  end
end
