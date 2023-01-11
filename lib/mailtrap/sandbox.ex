defmodule Mailtrap.Sandbox do
  @moduledoc """
  Mailtrap Sandbox API client

  Example

      %Mailtrap.Email{}
      |> Mailtrap.Email.put_from({"John Doe", "john@example.org"})
      |> Mailtrap.Email.put_to([{"Jane Doe", "jane@example.org"}])
      |> Mailtrap.Email.put_subject("Hello")
      |> Mailtrap.Email.put_text("Hi, Jane")
      |> Mailtrap.Sandbox.send()



email = %Mailtrap.Email{
  from: %{email: "kalys@osmonov.com", name: "Kalys Osmonov"},
  to: [%{email: "azem@osmonova.com", name: "Azem Osmonova"}],
  subject: "Hello",
  text: "bla bla"
}
Mailtrap.Sandbox.send(email, 2048945)
  """

  use Tesla

  plug(Mailtrap.DirectResponse)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.BaseUrl, "https://sandbox.api.mailtrap.io/api")
  # plug(Tesla.Middleware.BearerAuth, token: Application.get_env(:mailtrap, :api_token))
  plug Tesla.Middleware.Headers, [{"Api-Token", Application.get_env(:mailtrap, :api_token)}]
  plug Tesla.Middleware.Logger, log_level: :debug

  def send(email, inbox_id) do
    post("send/" <> Integer.to_string(inbox_id), email)
  end
end
