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

  # aliases
  alias ElixirServy.Conversation
  alias ElixirServy.BearController
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

  def route_response(%Conversation{method: "GET", path: "/wildthings"} = conversation) do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    _response = %Conversation{
      conversation
      | status: 200,
        res_body: "Bears, Lions, Tigers"
    }
  end

  def route_response(%Conversation{method: "GET", path: "/api/bears"} = conversation) do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    ElixirServy.Api.ApiBearController.index(conversation)
  end

  def route_response(%Conversation{method: "GET", path: "/bears"} = conversation) do
    # TODO: Create a new map that also has the response body
    # map is updating existing field `:res_body`
    BearController.index(conversation)
  end

  def route_response(%Conversation{method: "GET", path: "/bears/" <> id} = conversation) do
    params = Map.put(conversation.params, "id", id)
    BearController.show(conversation, params)
  end

  # POST REQUEST: name=Baloo&type=Brown
  def route_response(%Conversation{method: "POST", path: "/bears"} = conversation) do
    # TODO: Parse the last line of the request into a params map
    BearController.create(conversation, conversation.params)
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
        res_body: "No #{path} here!"
    }
  end

  def format_response(%Conversation{} = conversation) do
    # TODO: Use values in the map to create an HTTP response string
    _response = """
    HTTP/1.1 #{Conversation.full_status(conversation)}\r
    Content-Type: #{conversation.res_content_type}\r
    Content-Length: #{String.length(conversation.res_body)}\r
    \r
    #{conversation.res_body}
    """
  end
end
