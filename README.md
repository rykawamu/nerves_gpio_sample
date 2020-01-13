# nerves_gpio_sample

## 概要

NervesでGPIOを利用するサンプル。

### 動作確認したElixirとNerevesのバージョン

 - Elixir : 1.9.0 
 - Nerves : 1.5.1 
 - OS : macOS 10.14.6

### GPIOの利用準備

`circuits_gpio`を利用する。

mix.exsの中で`defp deps do`で次のように宣言する。宣言箇所は、配列内の後の方にしておく。

```
defp deps do
  [
    ~(中略)~

    {:circuits_gpio, "~> 0.4", targets: @all_targets},

  ]
end
```

### GPIOの利用方法

コード内でaliesを宣言

```
alias Circuits.GPIO
```

出力のHIGH／LOWを設定する。HIGH(「1」)で電圧が高くなり、LOW（「0」）でGNDになる。

```
# GPIOのポート17番を出力モードでオープン
{:ok, gpio17} = GPIO.open(17, :output)

# GPIOのポート17番をHIGHにする
GPIO.write(gpio17, 1)

:timer.sleep(3000)

# GPIOのポート17番をLOWにする
GPIO.write(gpio17, 0)
```


## コード以外に必要なもの

 - GPIOの出力を確認できる回路
 
  適当な抵抗値の抵抗とLEDで、電流が流れたらLEDが光る回路を二つ作る。
  プログラム中で出力モードのGPIOのPINに繋いだジャンパー線を回路のアノード側につなぎ、カソード側のジャンパー線はGNDにつなぐ。

