defmodule Timecraft.TodoistAdapter do
  alias Timecraft.Task

  def token, do: System.get_env("TODOIST_TOKEN")

  def all_tasks_by_date(date) do
    token()
    |> Todoixt.all_tasks()
    |> Stream.map(&build_task/1)
    |> Stream.filter(&(&1.due_date == date))
    |> Enum.sort_by(&{to_string(&1.due_time), &1.order})
  end

  defp build_task(item) do
    content = item["content"]
    title = parse_title(content)
    notes = if title != content, do: content

    %Task{
      external_id: item["id"],
      completed: item["completed"],
      title: title,
      notes: notes, 
      due_date: item |> get_in(~w(due date)) |> parse_date(),
      due_time: item |> get_in(~w(due datetime)) |> parse_time(get_in(item, ~w(due timezone))),
      order: item["order"]
    }
  end

  defp parse_title(content), do: Regex.replace(~r/\[(.+)\]\(.+\)/, content, "\\1")

  defp parse_date(nil), do: nil
  defp parse_date(str) when is_bitstring(str), do: Date.from_iso8601!(str)

  defp parse_time(nil, _), do: nil

  defp parse_time(str, zone) when is_bitstring(str) do 
    str 
    |> from_iso8601!()
    |> DateTime.shift_zone!(zone)
    |> DateTime.to_time()
  end

  defp from_iso8601!(str) do
    case DateTime.from_iso8601(str) do
      {:ok, datetime, _} -> datetime
      {:error, reason} -> raise "Error on DateTime.from_iso8601!/1, reason: #{reason}"
    end
  end
end
