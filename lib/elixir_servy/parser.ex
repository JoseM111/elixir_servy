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
    [top, param_string_last_line] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")

    [request_method, request_path, _] = String.split(request_line, " ")
    params = parse_params(param_string_last_line)

    _request = %Conversation{
      method: request_method,
      path: request_path,
      params: params
    }
  end

  def parse_params(params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end
end
