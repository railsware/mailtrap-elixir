defmodule Mailtrap do
  @moduledoc """
  Documentation for `Mailtrap`.
  """

  @type response() :: {:ok, any()} | {:error, Tesla.Env.t()}

  @doc """
  List accounts

  [Endpoint documentation](https://api-docs.mailtrap.io/docs/mailtrap-api-docs/f2baeca2d68cf-list-all-users-in-account)

  ## Example

      Mailtrap.accounts()
  """
  @spec accounts() :: response()
  def accounts() do
    client() |> Tesla.get("/accounts") |> handle_response()
  end

  @doc """
  List account accesses

  [Endpoint documentation](https://api-docs.mailtrap.io/docs/mailtrap-api-docs/f2baeca2d68cf-list-all-users-in-account)

  ## Examples

      Mailtrap.account_accesses(12345)
      # or
      Mailtrap.account_accesses(12345, project_ids: [10, 12])
      # or
      Mailtrap.account_accesses(12345, project_ids: [10, 12], inbox_ids: [22, 23])
  """
  @spec account_accesses(integer(), Tesla.Env.query()) :: response()
  def account_accesses(account_id, query \\ []) do
    client()
    |> Tesla.get(
      "/accounts/" <> to_string(account_id) <> "/account_accesses",
      query: query
    )
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
