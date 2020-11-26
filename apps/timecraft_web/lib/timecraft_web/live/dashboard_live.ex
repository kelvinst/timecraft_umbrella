defmodule TimecraftWeb.DashboardLive do
  use TimecraftWeb, :live_view

  alias Timecraft.DateUtils

  @impl true
  def mount(_params, _session, socket) do
    date = DateUtils.today()
    {:ok, assign(socket, tasks: Timecraft.tasks(date), date: date)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"date" => str}) do
    date = Date.from_iso8601!(str)

    socket
    |> assign(:page_title, "Tasks #{date}")
    |> assign(:date, date)
    |> assign(:tasks, Timecraft.tasks(date))
  end

  defp apply_action(socket, :index, _params) do
    date = DateUtils.today()

    socket
    |> assign(:page_title, "Tasks #{date}")
    |> assign(:date, date)
    |> assign(:tasks, Timecraft.tasks(date))
  end

  @impl true
  def handle_event("resolve_time_entries_conflicts", _, socket) do
    Timecraft.resolve_time_entries_conflicts(socket.assigns.date)
    {:noreply, put_flash(socket, :success, "Time entries conflicts successfully resolved!")}
  end
end
