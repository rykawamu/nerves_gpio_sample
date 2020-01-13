defmodule NervesGpioSampleTest do
  use ExUnit.Case
  doctest NervesGpioSample

  test "greets the world" do
    assert NervesGpioSample.hello() == :world
  end
end
