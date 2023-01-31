defmodule Mailtrap do
  @moduledoc """
  Mailtrap API client
  """

  use Tesla

  @doc """
  Generates client
  """
  @spec client(String.t()) :: Tesla.Client.t()
  def client(token) do
    middleware = [
      Mailtrap.DirectResponse,
      Tesla.Middleware.JSON,
      Tesla.Middleware.PathParams,
      {Tesla.Middleware.BaseUrl, "https://mailtrap.io/api"},
      {Tesla.Middleware.BearerAuth, token: token}
    ]

    Tesla.client(middleware)
  end
end
