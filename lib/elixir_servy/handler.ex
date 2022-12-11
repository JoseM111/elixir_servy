# handler.ex

defmodule Handler do
  def request_handler(request) do
    # example 1
    # conversation = parse_request(request)
    # conversation = route_response(conversation)
    # format_response(conversation)
    # -------------------------------------------
    # example 2
    # format_response(
    #   route_response(parse_request(request))
    # )

    # best convention below
    request
    |> parse_request()
    |> route_response()
    |> format_response()
  end

  # the parse functions changes a request to a key:value pair
  # lines = String.split(request, "\n")
  def parse_request(request) do
    # Example 1
    # first_line = request |> String.split("\n") |> List.first()
    # [method, path, _] = String.split(first_line, " ")
    # ---------------------------------------------------------
    # TODO: Parse the request string into the map:

    [request_method, request_path, _res_body] =
      request
      # passes request as a first arg
      |> String.split("\n")
      # List.first(): Returns the first element in
      # list or default if list is empty.
      # take the result of above
      |> List.first()
      |> String.split(" ")

    %{
      method: request_method,
      path: request_path,
      res_body: ""
    }
  end

  def route_response(conversation) do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    %{conversation | res_body: "Bears, Lions, Tigers"}
  end

  def format_response(conversation) do
    # TODO: Use values in the map to create an HTTP response string
    _response = """
    HTTP/1.1 200 OK
    Content-Type:text/html
    Content-Length: #{String.length(conversation.res_body)}

    #{conversation.res_body}
    """
  end
end

# ----------------------------------------------
IO.puts("=============== script ===============\n")

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

# -----------------------------------------------

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")

# -----------------------------------------------
# Handler.parse_request("")
# -----------------------------------------------

IO.puts("=============== script ===============\n\n")

Code.compiler_options(ignore_module_conflict: true)
