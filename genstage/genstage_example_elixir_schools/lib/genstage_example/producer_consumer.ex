defmodule GenstageExample.ProducerConsumer do
  @moduledoc """
  You may have noticed with our producer-consumer we’ve introduced a new option in init/1 and a new function: handle_events/3.
  With the subscribe_to option, we instruct GenStage to put us into communication with a specific producer.

  The handle_events/3 function is our workhorse, where we receive our incoming events,
   process them, and return our transformed set. As we’ll see consumers are implemented in much the same way,
   but the important difference is what our handle_events/3 function returns and how it’s used.
   When we label our process a producer_consumer, the second argument of our tuple — numbers in our case — is used to meet the demand of consumers downstream.
   In consumers this value is discarded.
  """
  use GenStage

  require Integer

  def start_link(_initial) do
    GenStage.start_link(__MODULE__, :state_doesnt_matter, name: __MODULE__)
  end

  def init(state) do
    {:producer_consumer, state, subscribe_to: [GenstageExample.Producer]}
  end

  def handle_events(events, _from, state) do
    numbers =
      events
      |> Enum.filter(&Integer.is_even/1)

    {:noreply, numbers, state}
  end
end
