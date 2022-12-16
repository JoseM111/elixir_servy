# bear_controller.ex

defmodule ElixirServy.BearController do
  # aliases
  alias ElixirServy.Conversation
  alias ElixirServy.Wildthings
  alias ElixirServy.Bear
  # ==================================================

  # constants `@` module attribute
  @template_path Path.expand("../../templates", __DIR__)

  def render_markup(conversation, template_file, bindings \\ []) do
    content =
      @template_path
      |> Path.join(template_file)
      |> EEx.eval_file(bindings)

    _response = %Conversation{conversation | status: 200, res_body: content}
  end

  def index(%Conversation{} = conversation) do
    # TODO: Transform the bear-list into an HTML list
    bears =
      Wildthings.get_list_of_bears()
      |> Enum.sort(&Bear.order_ascending_by_name/2)

    render_markup(conversation, "index.eex", bears: bears)
  end

  def show(%Conversation{} = conversation, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    render_markup(conversation, "show.eex", bear: bear)
  end

  def create(conversation, %{"name" => name, "type" => type} = _) do
    _response = %Conversation{
      conversation
      | status: 201,
        res_body: "Created a #{type} bear named #{name}!"
    }
  end
end
