defmodule Timecraft.DatetimeUtils do
  def from_iso8601!(str) do
    case DateTime.from_iso8601(str) do
      {:ok, datetime, _} -> datetime
      {:error, reason} -> raise "Error on DateTime.from_iso8601!/1, reason: #{reason}"
    end
  end
end
