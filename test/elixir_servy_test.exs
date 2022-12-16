defmodule ElixirServyTest do
  use ExUnit.Case
  doctest ElixirServy

  test "the truth" do
    assert 5 + 2 == 7
    refute 5 + 2 == 2
  end
end
