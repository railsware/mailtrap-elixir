defmodule Mailtrap.Sending do
  @moduledoc """
  Mailtrap Sending API client
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
      {Tesla.Middleware.BaseUrl, "https://send.api.mailtrap.io/api"},
      {Tesla.Middleware.BearerAuth, token: token}
    ]

    Tesla.client(middleware)
  end

  @doc """
  Sends an email
  """
  @spec send(Tesla.Client.t(), Mailtrap.Email.t()) :: {:ok, map()} | {:error, Tesla.Env.t()}
  def send(client, email) do
    post(client, "send", email)
  end
end
