defmodule Todoixt do
  @moduledoc """
  Documentation for `Todoixt`.
  """

  def all_tasks(token) do
    token
    |> client()
    |> Tesla.get!("tasks")
    |> handle_result()
  end

  defp client(token) do
    middlewares = [
      {Tesla.Middleware.BaseUrl, "https://api.todoist.com/rest/v1"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middlewares)
  end

  defp handle_result(%{status: status, body: body}) when status < 400, do: body
end
