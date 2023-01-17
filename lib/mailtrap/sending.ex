defmodule Mailtrap.Sending do
  @moduledoc """
  Mailtrap Sending API client

  """

  use Tesla

  plug(Mailtrap.DirectResponse)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.BaseUrl, "https://send.api.mailtrap.io/api")
  plug(Tesla.Middleware.BearerAuth, token: Application.get_env(:mailtrap, :api_token))

  def send(email) do
    post("send", email)
  end
end
