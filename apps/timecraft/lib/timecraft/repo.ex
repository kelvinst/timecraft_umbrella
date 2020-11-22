defmodule Timecraft.Repo do
  use Ecto.Repo,
    otp_app: :timecraft,
    adapter: Ecto.Adapters.Postgres
end
