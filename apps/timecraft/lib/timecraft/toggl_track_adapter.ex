defmodule Timecraft.TogglTrackAdapter do
  alias Timecraft.DatetimeUtils

  # TODO - user config
  def token, do: System.get_env("TOGGL_TRACK_TOKEN")

  # TODO - user config
  def zone, do: "America/Sao_Paulo"

  def resolve_time_entries_conflicts(date) do
    token = token()
    end_datetime = DateTime.new!(date, ~T[23:59:59.999], zone())

    date
    |> DateTime.new!(~T[00:00:00.000], zone())
    |> TogglTrack.all_time_entries(end_datetime, token)
    |> Stream.map(fn entry ->
      %{
        id: entry["id"],
        start: parse_datetime(entry["start"]),
        stop: parse_datetime(entry["stop"])
      }
    end)
    |> Enum.sort_by(& &1.start, DateTime)
    |> entries_to_update([])
    |> Enum.map(&TogglTrack.update_time_entry(&1.id, &1, token))
  end

  defp entries_to_update([], acc), do: acc
  defp entries_to_update([_], acc), do: acc
  defp entries_to_update([%{stop: nil} | rest], acc), do: entries_to_update(rest, acc)

  defp entries_to_update([x | [y | _] = rest], acc) do
    if DateTime.compare(x.stop, y.start) == :gt do
      entries_to_update(rest, [%{id: x.id, stop: y.start} | acc])
    else
      entries_to_update(rest, acc)
    end
  end

  defp parse_datetime(nil), do: nil
  defp parse_datetime(str) when is_bitstring(str), do: DatetimeUtils.from_iso8601!(str)
end
