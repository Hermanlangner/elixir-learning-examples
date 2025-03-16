defmodule Simulations.Repo do
  use Ecto.Repo,
    otp_app: :simulations,
    adapter: Ecto.Adapters.Postgres
end
