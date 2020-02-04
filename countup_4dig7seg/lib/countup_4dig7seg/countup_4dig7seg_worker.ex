defmodule Countup4dig7seg.Worker do
  use GenServer

  alias Circuits.GPIO

  @degit_disp_on 2
  @digit_disp_off 1
  @digit_loop_max 10
  @countup_max 2048
  @count_reset_gpio_no 12

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
    digit_gpio_no_list =
      Application.get_env(:countup_4dig7seg, :digit_gpio_no_list)
    gpio_no_list =
      Application.get_env(:countup_4dig7seg, :gpio_no_list)
    no_list = digit_gpio_no_list ++ gpio_no_list
    disp_led_loop(no_list, 8)
    spawn(fn -> blink_4digit_7led_forever(no_list, 0) end)
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
     10 -> [1,1,1,1,1,1,1,1]
      _ -> [1,1,1,1,1,1,1,0]
    end
  end

  defp anode_4digit_7led_blink(digit) do
    case digit do
      0 -> [1,0,0,0]
      1 -> [0,1,0,0]
      2 -> [0,0,1,0]
      3 -> [0,0,0,1]
      _ -> [0,0,0,0]
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

  # count up 4degit 7segment led

  defp blink_4digit_7led_forever(no_list, count) do
    disp_led_loop(no_list, count)
    next_count = countup(count)
    next_count = count_reset(next_count)
    blink_4digit_7led_forever(no_list, next_count)
  end

  defp countup(@countup_max), do: 0
  defp countup(count), do: rem(count + 1, @countup_max)

  defp count_reset(count) do
    {:ok, gpio} = GPIO.open(@count_reset_gpio_no, :input)
    result = GPIO.read(gpio)
    case result do
      1 -> 0
      _ -> count
    end
  end

  defp disp_led_loop(no_list, count) do
    1..@digit_loop_max |>
    Enum.each(fn _ -> blink_4digit_7led(no_list, count) end)
  end

  defp blink_4digit_7led(no_list, count) do
    # 1桁目
    blink_led(no_list, 3, count)
    # 10桁目
    blink_led(no_list, 2, count)
    # 100桁目
    blink_led(no_list, 1, count)
    # 1000桁目
    blink_led(no_list, 0, count)
  end

  defp get_led_list(digit,count) do
    anode_4digit_7led_blink(digit) ++
      anode_7led_blink(disp_digit_num(digit,count))
  end

  defp blink_led(no_list, digit, count) do
    led_list = get_led_list(digit,count)

    sumlist(no_list, led_list, [])
    |> Enum.map(fn m -> gpio_write_map(m) end)

    :timer.sleep(@degit_disp_on)

    sumlist(no_list, [0,0,0,0,1,1,1,1,1,1,1,1], [])
    |> Enum.map(fn m -> gpio_write_map(m) end)
    :timer.sleep(@digit_disp_off)
  end

  defp disp_digit_num(0, num), do: num |> div(1000) |> rem(10)
  defp disp_digit_num(1, num), do: num |> div(100) |> rem(10)
  defp disp_digit_num(2, num), do: num |> div(10) |> rem(10)
  defp disp_digit_num(3, num), do: num |> rem(10)
  defp disp_digit_num(_, num), do: num

end
