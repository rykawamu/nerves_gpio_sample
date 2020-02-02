defmodule Countup4dig7seg.Worker do
  use GenServer

  alias Circuits.GPIO

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    GenServer.cast(__MODULE__, :init)
    {:ok, state}
  end

  def handle_cast(:init, state) do
    run()
    {:noreply, state}
  end

  def run() do
    gpio_no_list =
      Application.get_env(:countup_4dig7seg, :gpio_no_list)
  end
end
