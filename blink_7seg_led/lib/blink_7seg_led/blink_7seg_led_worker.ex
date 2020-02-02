defmodule Blink7segLed.Worker do
  use GenServer

  alias Circuits.GPIO

  @seg7_led_sleep 1000
  @digit_loop  250

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    GenServer.cast(__MODULE__, :init)
    {:ok, state}
  end

  def handle_cast(:init, state) do
    run(:led_7seg)
    run(:led_7seg_4degit)
    {:noreply, state}
  end

  # 7seg led
  def run(:led_7seg) do
    gpio_no_list =
      Application.get_env(:blink_7seg_led, :gpio_no_list)
    spawn(fn -> blink_7led_forever(gpio_no_list, 0) end)
  end

  # 4digit 7seg led 
  def run(:led_7seg_4degit) do
    digit_gpio_no_list =
      Application.get_env(:blink_7seg_led, :digit_gpio_no_list)
    func_4digit = digit_gpio_no_list |>
                  blink_4digit_forever(0)
    spawn(fn -> func_4digit end)
  end

  ##########
  # 7 segment led
  ##########

  defp blink_7led_forever(gpio_no_list, count) do
    blink_7led(gpio_no_list, count)
    next_count = rem(count + 1, 10)
    blink_7led_forever(gpio_no_list, next_count)
  end

  defp blink_7led(gpio_no_list,count) do
    gpio_no_list
    |> sumlist(anode_7led_blink(count), [])
    |> Enum.map(fn m -> gpio_write_map(m) end)

    :timer.sleep(@seg7_led_sleep)
  end

  defp anode_7led_blink(count) do
    case count do
      0 -> [0,0,0,0,0,0,1,1]
      1 -> [1,0,0,1,1,1,1,1]
      2 -> [0,0,1,0,0,1,0,1]
      3 -> [0,0,0,0,1,1,0,1]
      4 -> [1,0,0,1,1,0,0,1]
      5 -> [0,1,0,0,1,0,0,1]
      6 -> [0,1,0,0,0,0,0,1]
      7 -> [0,0,0,1,1,0,1,1]
      8 -> [0,0,0,0,0,0,0,1]
      9 -> [0,0,0,0,1,0,0,1]
      _ -> [1,1,1,1,1,1,1,0]
    end
  end

  defp sumlist(gpio_list, num_list, total \\ [])
  defp sumlist([], [], total) do
    Enum.reverse(total)
  end
  defp sumlist([h1|t1], [], total) do
    sumlist(t1, [], [ %{:gpio_no => h1,:val => 0} | total])
  end
  defp sumlist([], [_h1|_t2], total) do
    Enum.reverse(total)
  end
  defp sumlist([h1|t1], [h2|t2], total) do
    sumlist(t1, t2, [ %{:gpio_no => h1,:val => h2} | total])
  end

  defp gpio_write_map(m) do
    gpio_write(m[:gpio_no], m[:val])
  end
  defp gpio_write(gpio_no, val) do
    {:ok, gpio} = GPIO.open(gpio_no, :output)
    GPIO.write(gpio, val)
  end

  ##########
  # 4 digit 7 segment led
  ##########

  defp blink_4digit_forever(digit_gpio_no_list, count) do
    blink_4digit_seq(digit_gpio_no_list, count)
    next_count = rem(count + 1, 4)
    blink_4digit_forever(digit_gpio_no_list, next_count)
  end

  defp blink_4digit_seq(digit_gpio_no_list, count) do
    digit_gpio_no_list
    |> sumlist(anode_4digit_7led_blink(count), [])
    |> Enum.map(fn m -> gpio_write_map(m) end)

    :timer.sleep(@digit_loop)
  end

  defp anode_4digit_7led_blink(digit) do
    case digit do
      0 -> [1,0,0,0]
      1 -> [0,1,0,0]
      2 -> [0,0,1,0]
      3 -> [0,0,0,1]
      _ -> [1,1,1,1]
    end
  end

end
