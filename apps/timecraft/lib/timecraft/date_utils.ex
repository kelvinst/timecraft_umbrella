defmodule Timecraft.DateUtils do
  # TODO make this configurable by user and remove the default value
  @timezone "America/Sao_Paulo"

  def today(timezone \\ @timezone) do
    DateTime.utc_now()
    |> DateTime.shift_zone!(timezone)
    |> DateTime.to_date()
  end
end
