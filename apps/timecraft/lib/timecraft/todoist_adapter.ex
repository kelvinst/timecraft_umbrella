defmodule Timecraft.TodoistAdapter do
  alias Timecraft.DatetimeUtils
  alias Timecraft.Project
  alias Timecraft.Task

  # TODO - user config
  def token, do: System.get_env("TODOIST_TOKEN")

  def all_tasks_by_date(date) do
    token = token()
    projects = Todoixt.all_projects(token)

    token
    |> Todoixt.all_tasks()
    |> Stream.map(&build_task(&1, projects))
    |> Stream.filter(&(&1.due_date == date))
    |> Enum.sort_by(&{to_string(&1.due_time), &1.order})
  end

  defp build_task(item, projects) do
    content = item["content"]
    title = parse_title(content)
    project = Enum.find(projects, &(&1["id"] == item["project_id"]))
    notes = if title != content, do: content

    %Task{
      external_id: item["id"],
      completed: item["completed"],
      title: title,
      notes: notes,
      due_date: item |> get_in(~w(due date)) |> parse_date(),
      due_time: item |> get_in(~w(due datetime)) |> parse_time(get_in(item, ~w(due timezone))),
      order: item["order"],
      project: build_project(project)    
    }
  end

  defp build_project(nil), do: nil

  defp build_project(item) do
    %Project{
      external_id: item["id"],
      name: item["name"],
      color: parse_color(item["color"])
    }
  end

  defp parse_color(30), do: "#b8256f"
  defp parse_color(31), do: "#db4035"
  defp parse_color(32), do: "#ff9933"
  defp parse_color(33), do: "#fad000"
  defp parse_color(34), do: "#afb83b"
  defp parse_color(35), do: "#7ecc49"
  defp parse_color(36), do: "#299438"
  defp parse_color(37), do: "#6accbc"
  defp parse_color(38), do: "#158fad"
  defp parse_color(39), do: "#14aaf5"
  defp parse_color(40), do: "#96c3eb"
  defp parse_color(41), do: "#4073ff"
  defp parse_color(42), do: "#884dff"
  defp parse_color(43), do: "#af38eb"
  defp parse_color(44), do: "#eb96eb"
  defp parse_color(45), do: "#e05194"
  defp parse_color(46), do: "#ff8d85"
  defp parse_color(47), do: "#808080"
  defp parse_color(48), do: "#b8b8b8"
  defp parse_color(49), do: "#ccac93"

  defp parse_title(content), do: Regex.replace(~r/\[(.+)\]\(.+\)/, content, "\\1")

  defp parse_date(nil), do: nil
  defp parse_date(str) when is_bitstring(str), do: Date.from_iso8601!(str)

  defp parse_time(nil, _), do: nil

  defp parse_time(str, zone) when is_bitstring(str) do
    str
    |> DatetimeUtils.from_iso8601!()
    |> DateTime.shift_zone!(zone)
    |> DateTime.to_time()
  end
end
