defmodule GenstageExample.Producer do
  use GenStage

  def start_link(name) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def produce_number(number) do
    GenServer.call(__MODULE__, {:produce_number, number}, 5000_0)
  end

  @impl true
  def init(:ok) do
    {:producer, {:queue.new(), 0}}
  end

  @impl true
  def handle_call({:produce_number, number}, from, {queue, demand}) do
    # IO.puts("Producer received number: #{number}")
    queue = :queue.in({number, from}, queue)
    dispatch_events(queue, demand)
  end

  @impl true
  def handle_demand(demand, {queue, _demand}) do
    dispatch_events(queue, demand)
  end

  defp dispatch_events(queue, demand) do
    {events, queue} = dequeue_events(queue, demand, [])
    {:noreply, events, {queue, demand - length(events)}}
  end

  defp dequeue_events(queue, 0, acc), do: {Enum.reverse(acc), queue}

  defp dequeue_events(queue, demand, acc) do
    case :queue.out(queue) do
      {:empty, queue} -> {Enum.reverse(acc), queue}
      {{:value, event}, queue} -> dequeue_events(queue, demand - 1, [event | acc])
    end
  end
end
