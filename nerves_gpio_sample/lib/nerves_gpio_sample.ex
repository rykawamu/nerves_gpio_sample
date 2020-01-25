defmodule NervesGpioSample do
  @moduledoc """
  Documentation for NervesGpioSample.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesGpioSample.hello
      :world

  """
  def hello do
    :world
  end

### GenServer経由の起動変更に伴い、利用しないためコメント化
#  alias Nerves.Leds
#  alias Circuits.GPIO
#
#  @led_on_sleep 4000
#  @led_off_sleep 1000
#
#  def start(_type, _args) do
#    led_list = Application.get_env(:nerves_gpio_sample, :led_list)
#    spawn(fn -> blink_list_forever(led_list) end)
#    {:ok, self()}
#  end
#
#  defp blink_list_forever(led_list) do
#    Enum.each(led_list, &blink(&1))
#    blink_list_forever(led_list)
#  end
#
#  defp blink(led_key) do
#    {:ok, gpio17} = GPIO.open(17, :output)
#    {:ok, gpio27} = GPIO.open(27, :output)
#
#    GPIO.write(gpio17, 1)
#    Leds.set([{led_key, true}])
#    :timer.sleep(@led_on_sleep)
#    GPIO.write(gpio17, 0)
#
#    GPIO.write(gpio27, 1)
#    Leds.set([{led_key, false}])
#    :timer.sleep(@led_off_sleep)
#    GPIO.write(gpio27, 0)
#
#    GPIO.close(gpio17)
#    GPIO.close(gpio27)
#  end

end
