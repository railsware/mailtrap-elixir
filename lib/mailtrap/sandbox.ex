defmodule Mailtrap.Sandbox do
  @moduledoc """
  Mailtrap Sandbox API client

  Example

    %Mailtrap.Email{}
    |> Mailtrap.Email.put_from("Kalys Osmonov", "kalys@osmonov.com")
    |> Mailtrap.Email.put_to([{"Lolek", "lolek@example.com"}, {"Bolek", "bolek@example.com"}])
    |> Mailtrap.Email.put_subject("Bla bla")
    |> Mailtrap.Email.put_text("Text bla bla")
    |> Mailtrap.Sandbox.send(2048945)
  """

  use Tesla

  plug(Mailtrap.DirectResponse)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.BaseUrl, "https://sandbox.api.mailtrap.io/api")
  plug(Tesla.Middleware.BearerAuth, token: Application.get_env(:mailtrap, :api_token))
  # plug(Tesla.Middleware.Logger, log_level: :debug)

  def send(email, inbox_id) do
    post("send/" <> Integer.to_string(inbox_id), email)
  end
end
