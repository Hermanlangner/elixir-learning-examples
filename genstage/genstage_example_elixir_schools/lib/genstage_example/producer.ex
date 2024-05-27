defmodule GenstageExample.Producer do
  @moduledoc """
  Notes from tutorial
  The two most important parts to take note of here are init/1 and handle_demand/2. In init/1 we set the initial state as we’ve done in our GenStage, but more importantly we label ourselves as a producer. The response from our init/1 function is what GenStage relies upon to classify our process.

  The handle_demand/2 function is where the majority of our producer is defined. It must be implemented by all GenStage producers. Here we return the set of numbers demanded by our consumers and increment our counter. The demand from consumers, demand in our code above, is represented as an integer corresponding to the number of events they can handle; it defaults to 1000.
  """
  use GenStage

  def start_link(initial \\ 0) do
    GenStage.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def init(counter), do: {:producer, counter}

  def handle_demand(demand, state) do
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end
