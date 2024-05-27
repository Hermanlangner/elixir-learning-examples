defmodule GenstageExample.ProducerConsumer do
  use GenStage

  def start_link(name) do
    GenStage.start_link(__MODULE__, :ok, name: name)
  end

  @impl true
  def init(:ok) do
    {:producer_consumer, :ok, subscribe_to: [GenstageExample.Producer]}
  end

  @impl true
  def handle_events(events, _from, state) do
    IO.puts("ProducerConsumer #{inspect(self())} handling events: #{inspect(events)}")

    multiplied_events =
      Enum.map(events, fn {number, from} ->
        {number * 2, from}
      end)

    {:noreply, multiplied_events, state}
  end
end
