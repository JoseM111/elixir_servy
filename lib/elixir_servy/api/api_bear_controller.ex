# api_bear_controller.ex
defmodule ElixirServy.Api.ApiBearController do
  alias ElixirServy.Conversation

  def index(%Conversation{} = conversation) do
    json_to_encoded =
      ElixirServy.Wildthings.get_list_of_bears()
      |> Poison.encode!()

    _json_response = %Conversation{
      conversation
      | status: 200,
        res_content_type: "application/json",
        res_body: json_to_encoded
    }
  end
end
