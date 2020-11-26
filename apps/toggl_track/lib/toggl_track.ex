defmodule TogglTrack do
  @moduledoc """
  Documentation for `TogglTrack`.
  """

  def all_time_entries(start_datetime, end_datetime, token) do
    token
    |> client()
    |> Tesla.get!("time_entries",
      query: [
        start_date: DateTime.to_iso8601(start_datetime),
        end_date: DateTime.to_iso8601(end_datetime)
      ]
    )
    |> handle_result()
  end

  def update_time_entry(id, attrs, token) do
    token
    |> client()
    |> Tesla.put!("time_entries/#{id}", %{time_entry: attrs})
    |> handle_result("data")
  end

  defp client(token) do
    middlewares = [
      {Tesla.Middleware.BaseUrl, "https://api.track.toggl.com/api/v8"},
      Tesla.Middleware.JSON,
      Tesla.Middleware.Logger,
      {Tesla.Middleware.Headers,
       [
         {"Content-Type", "application/json"},
         {"Authorization", "Basic " <> Base.encode64("#{token}:api_token")}
       ]}
    ]

    Tesla.client(middlewares)
  end

  defp handle_result(%{status: status, body: body}, field \\ nil) when status < 400 do
    if field do
      body[field]
    else
      body
    end
  end
end
