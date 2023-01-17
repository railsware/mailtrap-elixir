defmodule Mailtrap.Sandbox do
  @moduledoc """
  Mailtrap Sandbox API client

  ## Example

    {:ok, data} = File.read(Path.join(__DIR__, "test/support/invoice.pdf"))
    attachment = Mailtrap.Email.Attachment.build(data, "invoice1.pdf")
    %Mailtrap.Email{}
    |> Mailtrap.Email.put_from("Sender", "sender@example.com")
    |> Mailtrap.Email.put_to([{"Lolek", "lolek@example.com"}, {"Bolek", "bolek@example.com"}])
    |> Mailtrap.Email.put_subject("Bla bla")
    |> Mailtrap.Email.put_text("Text bla bla")
    |> Mailtrap.Email.put_attachments([attachment])
    |> Mailtrap.Sandbox.send(111) # 111 is inbox id
  """

  use Tesla

  plug(Mailtrap.DirectResponse)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.BaseUrl, "https://sandbox.api.mailtrap.io/api")
  plug(Tesla.Middleware.BearerAuth, token: Application.get_env(:mailtrap, :api_token))

  def send(email, inbox_id) do
    post("send/" <> Integer.to_string(inbox_id), email)
  end
end
