defmodule Timecraft do
  @moduledoc """
  Timecraft keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Timecraft.TodoistAdapter
  alias Timecraft.TogglTrackAdapter

  def tasks(date), do: TodoistAdapter.all_tasks_by_date(date)

  def resolve_time_entries_conflicts(date),
    do: TogglTrackAdapter.resolve_time_entries_conflicts(date)
end
