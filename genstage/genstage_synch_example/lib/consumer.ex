defmodule GenstageExample.Consumer do
  use GenStage

  def start_link(name) do
    GenStage.start_link(__MODULE__, {:ok, name}, name: name)
  end

  @impl true
  def init({:ok, name}) do
    {:consumer, name,
     subscribe_to: [
       {:producer_consumer_1, max_demand: 1},
       {:producer_consumer_2, max_demand: 1},
       {:producer_consumer_3, max_demand: 1},
       {:producer_consumer_4, max_demand: 1},
       {:producer_consumer_5, max_demand: 1},
       {:producer_consumer_6, max_demand: 1},
       {:producer_consumer_7, max_demand: 1},
       {:producer_consumer_8, max_demand: 1},
       {:producer_consumer_9, max_demand: 1},
       {:producer_consumer_10, max_demand: 1}
     ]}
  end

  @impl true
  def handle_events(events, _from, name) do
    # IO.puts("Consumer #{name}")

    Enum.each(events, fn {number, from} ->
      # Simulate processing time
      :timer.sleep(1000)
      result = number * 3
      #   IO.puts("Consumer #{name} processed number: #{number}, result: #{result}")
      GenStage.reply(from, result)
    end)

    {:noreply, [], name}
  end
end
