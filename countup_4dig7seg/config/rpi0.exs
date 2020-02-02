use Mix.Config

config :countup_4dig7seg, led_list: [:green]
config :countup_4dig7seg, gpio_no_list: [17,27,23,24,25,22,26,16]
config :countup_4dig7seg, digit_gpio_no_list: [5,6,13,19]
config :nerves_leds, names: [green: "led0"]
