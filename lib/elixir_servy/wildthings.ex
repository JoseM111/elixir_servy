# wildthings.ex

defmodule ElixirServy.Wildthings do
  alias ElixirServy.Bear

  def get_list_of_bears do
    [
      %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", type: "Black"},
      %Bear{id: 3, name: "Paddington", type: "Brown"},
      %Bear{id: 4, name: "Scareface", type: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snow", type: "Polar"},
      %Bear{id: 6, name: "Brutas", type: "Grizzly"},
      %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
      %Bear{id: 8, name: "Roscoe", type: "Panda"},
      %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
      %Bear{id: 10, name: "Kenai", type: "Grizzly"}
    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(
      get_list_of_bears(),
      fn bear -> bear.id == id end
    )
  end

  # fallthrough for if id is a string/binary
  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear()
  end
end
