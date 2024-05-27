defmodule GenstageExample.Application do
  use Application

  def start(_type, _args) do
    children = [
      {GenstageExample.ProducerSupervisor, 1},
      {GenstageExample.ProducerConsumerSupervisor, 10},
      {GenstageExample.ConsumerSupervisor, 200}
    ]

    opts = [strategy: :one_for_one, name: GenstageExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
