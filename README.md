<!-- livebook:{"persist_outputs":true} -->

# Servy notebook

## Section->EPIC0001: Immutable Data

```elixir
conversation = %{
  method: "GET",
  path: "/wildthings",
  res_body: "Bears, Lions, Tigers"
}
```

<!-- livebook:{"output":true} -->

```
%{method: "GET", path: "/wildthings", res_body: "Bears, Lions, Tigers"}
```

```elixir
conversation[:method]
```

<!-- livebook:{"output":true} -->

```
"GET"
```

```elixir
conversation[:path]
```

<!-- livebook:{"output":true} -->

```
"/wildthings"
```

```elixir
conversation.method
```

<!-- livebook:{"output":true} -->

```
"GET"
```

### dot notation only works if the keys in the %map are `:atoms`

#### Example

<!-- livebook:{"force_markdown":true} -->

```elixir
# key does not exist in %{map}
conversation.mike
```

#### Output

<!-- livebook:{"force_markdown":true} -->

```elixir
# will output an error
** (KeyError) key
:mike not found in: %{method: "GET", path: "/wildthings", res_body: "Bears, Lions, Tigers"}
```

<!-- livebook:{"break_markdown":true} -->

### def put(map, key, value)

### `@spec put(map(), key(), value()) :: map()`

Puts the given value under `key` in `map`.

#### Examples

<!-- livebook:{"force_markdown":true} -->

```elixir
my_map = %{a: 1}
Map.put(my_map, :b, 2)
output - %{a: 1, b: 2}

Map.put(%{a: 1, b: 2}, :a, 3)
output - %{a: 3, b: 2}
```

```elixir
Map.put(conversation, :res_body, "Bears")
```

<!-- livebook:{"output":true} -->

```
%{method: "GET", path: "/wildthings", res_body: "Bears"}
```

### All data in elixir is immutable. So to add the new key/value pair to our conversation map we have to re-bind the put added data to our conversation map

```elixir
conversation = Map.put(conversation, :res_body, "Bears")
```

<!-- livebook:{"output":true} -->

```
%{method: "GET", path: "/wildthings", res_body: "Bears"}
```

```elixir
# test to see if the data was updated
IO.inspect(conversation, label: "(|the conversation map updated|)\n")
```

<!-- livebook:{"output":true} -->

```
(|the conversation map updated|)
: %{method: "GET", path: "/wildthings", res_body: "Bears"}
```

<!-- livebook:{"output":true} -->

```
%{method: "GET", path: "/wildthings", res_body: "Bears"}
```

### You can also use a shortcut syntax to put a new value into a copy of the conversation map. This shorcut only works when you modify the fields that already exist in a map.

```elixir
conversation = %{conversation | res_body: "Bears, Lions, Tigers"}
```

<!-- livebook:{"output":true} -->

```
%{method: "GET", path: "/wildthings", res_body: "Bears, Lions, Tigers"}
```

```elixir
# test to see if the data was updated
IO.inspect(conversation, label: "(|the conversation map updated again!!|)\n")
```

<!-- livebook:{"output":true} -->

```
(|the conversation map updated again!!|)
: %{method: "GET", path: "/wildthings", res_body: "Bears, Lions, Tigers"}
```

<!-- livebook:{"output":true} -->

```
%{method: "GET", path: "/wildthings", res_body: "Bears, Lions, Tigers"}
```

---

---

## Section->EPIC0001: Function Clauses

### Pattern matching allows for less use of if conditionals and a cleaner way to control the flow of your program

#### Example

<!-- livebook:{"force_markdown":true} -->

```elixir
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

  # =============== utility-functions ===============
  defp status_code(code) do
    _code =
      %{
        200 => "OK",
        201 => "Created",
        401 => "Unauthorized",
        403 => "Forbidden",
        404 => "Not Found",
        500 => "Internal Server Error"
      }[code]#<--
  end

  # OR

  defp status_code(code) do
    codes = %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }

    codes[code]#<--
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
GET /bears HTTP/1.1
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
# -----------------------------------------------

response = Handler.request_handler(request)
IO.puts("(|request-response|):\n#{response}")
```

#### output

<!-- livebook:{"force_markdown":true} -->

```elixir
=============== script ===============

(|conversation map before request|)
: %{method: "GET", path: "/wildthings", res_body: "", status: nil}
(|request-response|):
HTTP/1.1 200 OK
Content-Type:text/html
Content-Length: 20

Bears, Lions, Tigers

(|conversation map before request|)
: %{method: "GET", path: "/bears", res_body: "", status: nil}
(|request-response|):
HTTP/1.1 200 OK
Content-Type:text/html
Content-Length: 25

Teddy, Smokey, Paddington

(|conversation map before request|)
: %{method: "GET", path: "/bigfoot", res_body: "", status: nil}
(|request-response|):
HTTP/1.1 404 Not Found
Content-Type:text/html
Content-Length: 26

No path found for /bigfoot

=============== script ===============
```

<!-- livebook:{"break_markdown":true} -->

### pattern matching a route by concatenated a `id` to a route function

#### Example

<!-- livebook:{"force_markdown":true} -->

```elixir
def route_response(conversation, "GET", "/bears/" <> id) do
    _response = %{
      conversation
      | status: 200,
        res_body: "Bear #{id}"
    }
end
```

#### output

<!-- livebook:{"force_markdown":true} -->

```elixir
=============== script ===============

(|conversation map before request|)
: %{method: "GET", path: "/wildthings", res_body: "", status: nil}
(|request-response|):
HTTP/1.1 200 OK
Content-Type:text/html
Content-Length: 20

Bears, Lions, Tigers

(|conversation map before request|)
: %{method: "GET", path: "/bears/1", res_body: "", status: nil}
(|request-response|):
HTTP/1.1 200 OK
Content-Type:text/html
Content-Length: 6

Bear 1

(|conversation map before request|)
: %{method: "GET", path: "/bigfoot", res_body: "", status: nil}
(|request-response|):
HTTP/1.1 404 Not Found
Content-Type:text/html
Content-Length: 26

No path found for /bigfoot

=============== script ===============
```

## Section->EPIC0002: Mixed

### Refactored parse_request function inside its own module with a private helper function

##### Example

<!-- livebook:{"force_markdown":true} -->

```elixir
def parse_request(request) do
    alias ElixirServy.Conversation

    # Example 1
    # first_line = request |> String.split("\n") |> List.first()
    # [method, path, _] = String.split(first_line, " ")
    # ---------------------------------------------------------
    # TODO: Parse the request string into the map:
    [top_level_of_request, request_bottom_body_query] = String.split(request, "\n\n")

    # the `_` is for `http_headers_in_a_list` that we dont need
    [first_line_of_request | _] = String.split(top_level_of_request, "\n")

    [request_method, request_path, _] = String.split(first_line_of_request, " ")
    params = parse_params(request_bottom_body_query)

    _request = %Conversation{
      method: request_method,
      path: request_path,
      params: params
    }
  end

  def parse_params(params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end
```

#### Output

<!-- livebook:{"force_markdown":true} -->

```elixir
=============== script ===============
1. top_level_of_request: "POST /bears HTTP/1.1\nHost: example.com\nUser-Agent: ExampleBrowser/1.0\nAccept: */*\nContent-Type: application/x-www-form-urlencoded\nContent-Length: 21"
2. request_bottom_body_query: "name=Baloo&type=Brown\n"
3. first_line_of_request: "POST /bears HTTP/1.1"
4. http_header_in_a_list: ["Host: example.com", "User-Agent: ExampleBrowser/1.0", "Accept: */*",
 "Content-Type: application/x-www-form-urlencoded", "Content-Length: 21"]
5. parse_params(params_string)/1: %{"name" => "Baloo", "type" => "Brown"}
(|conversation map before request [GET]|)
: %ElixirServy.Conversation{
  method: "POST",
  path: "/bears",
  params: %{"name" => "Baloo", "type" => "Brown"},
  res_body: "",
  status: nil
}
(|request-response [POST]|):
HTTP/1.1 (201) (Created)
Content-Type:text/html
Content-Length: 37

Created a (Brown)
bear named (Baloo)
=============== script ===============
}
```

<!-- livebook:{"break_markdown":true} -->

### Quick example of recursion in `elixir`

```elixir
defmodule Recursive do
  def recursive_loop([head | tail]) do
    IO.puts("Head: #{head} Tail: #{inspect(tail)}")
    recursive_loop(tail)
  end

  def recursive_loop([]), do: IO.puts("Done!")
end

# =============================================
Recursive.recursive_loop([1, 2, 3, 4, 5])
```

<!-- livebook:{"output":true} -->

```
Head: 1 Tail: [2, 3, 4, 5]
Head: 2 Tail: [3, 4, 5]
Head: 3 Tail: [4, 5]
Head: 4 Tail: [5]
Head: 5 Tail: []
Done!
```

<!-- livebook:{"output":true} -->

```
:ok
```
