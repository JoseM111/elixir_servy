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
    |> log_request()
    |> route_response()
    |> format_response()
  end

  def log_request(conversation) do
    IO.inspect(
      conversation,
      label: "(|conversation map before request|)\n"
    )
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

    _request = %{
      method: request_method,
      path: request_path,
      res_body: "",
      status: nil
    }
  end

  # pattern matching routes with overloaded functions
  def route_response(conversation) do
    route_response(
      conversation,
      conversation.method,
      conversation.path
    )
  end

  def route_response(conversation, "GET", "/wildthings") do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    _response = %{
      conversation
      | status: 200,
        res_body: "Bears, Lions, Tigers"
    }
  end

  def route_response(conversation, "GET", "/bears") do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    _response = %{
      conversation
      | status: 200,
        res_body: "Teddy, Smokey, Paddington"
    }
  end

  def route_response(conversation, "GET", "/bears/" <> id) do
    _response = %{
      conversation
      | status: 200,
        res_body: "Bear #{id}"
    }
  end

  # no path matches than the pattern matching will
  # default to this path. this function should only
  # be called if known of the other functions match
  # and should be below all the other route_response
  # functions with routes in the module
  def route_response(conversation, _method, path) do
    _response = %{
      conversation
      | status: 404,
        res_body: "No path found for #{path}"
    }
  end

  def format_response(conversation) do
    # TODO: Use values in the map to create an HTTP response string
    _response = """
    HTTP/1.1 #{conversation.status} #{status_code(conversation.status)}
    Content-Type:text/html
    Content-Length: #{String.length(conversation.res_body)}

    #{conversation.res_body}
    """
  end

  # =============== utility-functions ===============
  defp status_code(code) do
    codes = %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    codes[code]
  end
end

# ----------------------------------------------
IO.puts("=============== script ===============\n")
# request 1
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
# -----------------------------------------------
# request 2
request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
# -----------------------------------------------
# request 3
request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
# -----------------------------------------------
# Handler.parse_request("")
# -----------------------------------------------

IO.puts("=============== script ===============\n\n")

Code.compiler_options(ignore_module_conflict: true)
