defmodule NervesGpioSample.Led do
  use GenServer   # <- NervesGpioSample.LedがGenServerとして振る舞うように記述

  alias Nerves.Leds
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
    led_list = Application.get_env(:nerves_gpio_sample, :led_list)
    spawn(fn -> blink_list_forever(led_list) end)
  end

  defp blink_list_forever(led_list) do
    Enum.each(led_list, &blink(&1))
    blink_list_forever(led_list)
  end

  defp blink(led_key) do
    1..10 |> Enum.each(fn _ -> led_set(led_key,{300, 300}) end)
 
    {:ok, gpio17} = GPIO.open(17, :output)
    {:ok, gpio27} = GPIO.open(27, :output)

    GPIO.write(gpio17, 1)
    led_set(led_key,{3000, 2000})
    GPIO.write(gpio17, 0)

    GPIO.write(gpio27, 1)
    led_set(led_key,{2000, 3000})
    GPIO.write(gpio27, 0)
  end

  defp led_set(led_key, {on_time, off_time}) do
    Leds.set([{led_key, true}])
    :timer.sleep(on_time)
    Leds.set([{led_key, false}])
    :timer.sleep(off_time)
  end

end
