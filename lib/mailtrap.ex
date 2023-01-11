defmodule Mailtrap do
  @moduledoc """
  Mailtrap API client
  """

  use Tesla

  plug(Mailtrap.DirectResponse)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.PathParams)
  plug(Tesla.Middleware.BaseUrl, "https://mailtrap.io/api")
  plug(Tesla.Middleware.BearerAuth, token: Application.get_env(:mailtrap, :api_token))
end
