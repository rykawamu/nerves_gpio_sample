use Mix.Config
config :blink_7seg_led, led_list: [:green]
config :blink_7seg_led, gpio_no_list: [17,27,23,24,25,22,26,16]
config :blink_7seg_led, digit_gpio_no_list: [5,6,13,19]
config :nerves_leds, names: [green: "led0"]
