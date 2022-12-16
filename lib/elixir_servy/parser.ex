# parser.ex

defmodule ElixirServy.Parser do
  # aliases
  alias ElixirServy.Conversation

  # the parse functions changes a request to a key:value pair
  # lines = String.split(request, "\n")
  def parse_request(request) do
    # Example 1
    # first_line = request |> String.split("\n") |> List.first()
    # [method, path, _] = String.split(first_line, " ")
    # ---------------------------------------------------------
    # TODO: Parse the request string into the map:
    [top_level_of_request, request_bottom_body_query] = String.split(request, "\r\n\r\n")

    # the `_` is for `http_headers_in_a_list` that we dont need
    [first_line_of_request | http_headers_in_a_list] = String.split(top_level_of_request, "\r\n")

    [request_method, request_path, _] = String.split(first_line_of_request, " ")

    headers = parse_headers(http_headers_in_a_list, %{})
    params = parse_params(headers["Content-Type"], request_bottom_body_query)

    _request = %Conversation{
      method: request_method,
      path: request_path,
      params: params,
      headers: headers
    }
  end

  def parse_headers([head | tail], %{} = headers) do
    [key, value] = String.split(head, ": ")
    # put: Map.put(map, key, value)
    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end

  @doc """
  terminating function: will run as a
  fallthrough, for when our list is empty
  """
  def parse_headers([], headers), do: headers

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Examples
      iex> params_string = "name=Baloo&type=Brown"
      iex> ElixirServy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{"name" => "Baloo", "type" => "Brown"}
      iex> ElixirServy.Parser.parse_params("multipart/form-data", params_string)
      %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  # fallthrough function
  def parse_params(_, _), do: %{}
end
