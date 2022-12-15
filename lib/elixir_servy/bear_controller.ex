# bear_controller.ex

defmodule ElixirServy.BearController do
  # aliases
  alias ElixirServy.Conversation
  alias ElixirServy.Wildthings
  alias ElixirServy.Bear

  defp bears_items(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(%Conversation{} = conversation) do
    # TODO: Transform the bear-list into an HTML list
    items =
      Wildthings.get_list_of_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_ascending_by_name/2)
      |> Enum.map(&bears_items/1)
      |> Enum.join()

    %Conversation{
      conversation
      | status: 200,
        res_body: "<ul>#{items}</ul>"
    }
  end

  def show(%Conversation{} = conversation, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    _response = %Conversation{
      conversation
      | status: 200,
        res_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"
    }
  end

  def create(conversation, %{"name" => name, "type" => type} = _) do
    _response = %Conversation{
      conversation
      | status: 201,
        res_body: """
        Created a (#{type})
        bear named (#{name})
        """
    }
  end
end
