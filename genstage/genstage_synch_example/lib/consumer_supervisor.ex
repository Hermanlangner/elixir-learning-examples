defmodule GenstageExample.ConsumerSupervisor do
  use Supervisor

  def start_link(count) do
    Supervisor.start_link(__MODULE__, count, name: __MODULE__)
  end

  def init(count) do
    children =
      for i <- 1..count do
        name = String.to_atom("consumer_#{i}")
        Supervisor.child_spec({GenstageExample.Consumer, name}, id: name)
      end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
