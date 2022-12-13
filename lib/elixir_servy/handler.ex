# handler.ex

defmodule ElixirServy.Handler do
  @moduledoc "Handles HTTP requests"
  import ElixirServy.Plugins,
    only: [
      rewrite_path: 1,
      log_request: 1,
      track_status_code: 1
    ]

  import ElixirServy.Parser, only: [parse_request: 1]

  alias ElixirServy.Conversation
  # =================================================

  # declaring a compile-time constant
  @pages_path Path.expand("../../pages", __DIR__)

  @doc "Transforms the request into a response"
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
    |> rewrite_path()
    |> log_request()
    |> route_response()
    |> track_status_code()
    |> format_response()
  end

  @doc "pattern matching routes with overloaded functions"
  # def route_response(conversation) do
  #   route_response(
  #     conversation,
  #     conversation.method,
  #     conversation.path
  #   )
  # end

  def route_response(%Conversation{method: "GET", path: "/wildthings"} = conversation) do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    _response = %Conversation{
      conversation
      | status: 200,
        res_body: "Teddy, Smokey, Paddington"
    }
  end

  def route_response(%Conversation{method: "GET", path: "/bears"} = conversation) do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    _response = %Conversation{
      conversation
      | status: 200,
        res_body: "Teddy, Smokey, Paddington"
    }
  end

  def route_response(%Conversation{method: "GET", path: "/bears/" <> id} = conversation) do
    _response = %Conversation{
      conversation
      | status: 200,
        res_body: "Bear #{id}"
    }
  end

  # POST REQUEST: name=Baloo&type=Brown
  def route_response(%Conversation{method: "POST", path: "/bears"} = conversation) do
    # TODO: Parse the last line of the request into a params map
    params = %{"name" => "Baloo", "type" => "Brown"}

    _response = %Conversation{
      conversation
      | status: 201,
        res_body: """
        Created a (#{conversation.params["type"]})
        bear named (#{conversation.params["name"]})
        """
    }
  end

  # pattern matching the route by way of a file
  def route_response(%Conversation{method: "GET", path: "/about"} = conversation) do
    IO.puts("\n(|case route response|):\n")

    file_path =
      @pages_path
      |> Path.join("about.html")

    case File.read(file_path) do
      # first pattern that matches wins
      {:ok, content} ->
        %Conversation{
          conversation
          | status: 200,
            res_body: content
        }

      {:error, :enoent} ->
        %Conversation{
          conversation
          | status: 404,
            res_body: "File not found!!"
        }

      {:error, reason} ->
        %Conversation{
          conversation
          | status: 500,
            res_body: "File error: #{reason}"
        }
    end
  end

  # no path matches than the pattern matching will
  # default to this path. this function should only
  # be called if known of the other functions match
  # and should be below all the other route_response
  # functions with routes in the module
  def route_response(%Conversation{path: path} = conversation) do
    _response = %Conversation{
      conversation
      | status: 404,
        res_body: "No path found for #{path}"
    }
  end

  def format_response(%Conversation{} = conversation) do
    # TODO: Use values in the map to create an HTTP response string
    _response = """
    HTTP/1.1 #{Conversation.full_status(conversation)}
    Content-Type:text/html
    Content-Length: #{String.length(conversation.res_body)}

    #{conversation.res_body}
    """
  end
end

# ----------------------------------------------
alias ElixirServy.Handler

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
IO.puts("-----------------------------------------------")
# request 2
request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
IO.puts("-----------------------------------------------")
# request 3
request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
IO.puts("-----------------------------------------------")

# request 4
request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
IO.puts("-----------------------------------------------")

# request 5
request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
IO.puts("-----------------------------------------------")

# request 5
request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Handler.request_handler(request)
IO.puts("(|request-response [POST]|):\n#{response}")
IO.puts("-----------------------------------------------")

IO.puts("=============== script ===============\n\n")

Code.compiler_options(ignore_module_conflict: true)
