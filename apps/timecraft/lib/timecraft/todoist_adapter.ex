defmodule Timecraft.TodoistAdapter do
  def all_tasks_by_date(date) do
    token()
    |> Todoixt.all_tasks()
    |> Enum.filter(fn task ->
      get_in(task, ["due", "date"]) == Date.to_iso8601(date)
    end)
  end

  def token, do: System.get_env("TODOIST_TOKEN")
end
