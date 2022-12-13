# plugins.ex

defmodule ElixirServy.Plugins do
  alias ElixirServy.Conversation

  @doc "Logs 404 requests"
  def track_status_code(%Conversation{status: 404, path: path} = conversation) do
    IO.puts("WARNING: (#{path}) is on the loose!!!")
    conversation
  end

  # default
  def track_status_code(%Conversation{} = conversation), do: conversation

  # reroutes any path that is `/wildlife` to ->`/wildthings`
  def rewrite_path(%Conversation{path: "/wildlife"} = conversation) do
    _path = %{conversation | path: "/wildthings"}
  end

  # fallthrough function match for all other routes
  def rewrite_path(%Conversation{} = conversation), do: conversation

  def log_request(%Conversation{} = conversation) do
    IO.inspect(
      conversation,
      label: "(|conversation map before request|)\n"
    )
  end
end
