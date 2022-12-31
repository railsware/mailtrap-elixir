defmodule Mailtrap do
  @moduledoc """
  Documentation for `Mailtrap`.
  """

  @doc """
  List accounts
  """
  def accounts() do
    client() |> Tesla.get("/accounts") |> handle_response()
  end

  def account_accesses(account_id, project_ids \\ [], inbox_ids \\ []) do
    client()
    |> Tesla.get("/accounts/" <> to_string(account_id) <> "/account_accesses")
    |> handle_response()
  end

  defp client() do
    token = Application.get_env(:mailtrap, :api_token)

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://mailtrap.io/api"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BearerAuth, token: token}
    ]

    Tesla.client(middleware)
  end

  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({_, response}), do: {:error, response}
end
