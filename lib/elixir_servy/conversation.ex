# conversation.ex

defmodule ElixirServy.Conversation do
  alias ElixirServy.Conversation
  @doc "the name of the struct is the same as the module.
       you cannot declare more than one struct in a module"
  defstruct method: "", path: "", res_body: "", status: nil

  def full_status(%Conversation{} = conversation) do
    "#{conversation.status} #{status_code(conversation.status)}"
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
