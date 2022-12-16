defmodule ParserTest do
  use ExUnit.Case
  doctest ElixirServy.Parser
  # we need to alias in the Parser.ex to test it
  alias ElixirServy.Parser

  test "parses a list of header filed into a map" do
    header = ["A: 1", "B: 2"]

    # using our parse_header function to test
    pa_headers = Parser.parse_headers(header, %{})
    assert pa_headers == %{"A" => "1", "B" => "2"}
  end
end
