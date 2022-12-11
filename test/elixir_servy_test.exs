defmodule ElixirServyTest do
  use ExUnit.Case
  doctest ElixirServy

  test "greets the world" do
    assert ElixirServy.hello() == :world
  end
end
