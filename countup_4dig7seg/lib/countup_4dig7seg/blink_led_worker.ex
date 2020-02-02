defmodule BlinkLed.Worker do
  use GenServer

  alias Nerves.Leds

  @led_on_sleep 4000
  @led_off_sleep 1000

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
    led_list =
      Application.get_env(:countup_4dig7seg, :led_list)
    spawn(fn -> blink_list_forever(led_list) end)
  end

  defp blink_list_forever(led_list) do
    Enum.each(led_list, &blink(&1))
    blink_list_forever(led_list)
  end

  defp blink(led_key) do
    Leds.set([{led_key, true}])
    :timer.sleep(@led_on_sleep)
    Leds.set([{led_key, false}])
    :timer.sleep(@led_off_sleep)
  end

end
