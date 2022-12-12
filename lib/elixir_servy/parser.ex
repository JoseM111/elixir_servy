# parser.ex

defmodule ElixirServy.Parser do
  # the parse functions changes a request to a key:value pair
  # lines = String.split(request, "\n")
  def parse_request(request) do
    alias ElixirServy.Conversation

    # Example 1
    # first_line = request |> String.split("\n") |> List.first()
    # [method, path, _] = String.split(first_line, " ")
    # ---------------------------------------------------------
    # TODO: Parse the request string into the map:

    [request_method, request_path, _] =
      request
      # passes request as a first arg
      |> String.split("\n")
      # List.first(): Returns the first element in
      # list or default if list is empty.
      # take the result of above
      |> List.first()
      |> String.split(" ")

    _request = %Conversation{
      method: request_method,
      path: request_path
    }
  end
end
