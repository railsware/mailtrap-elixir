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

  @doc """
  Generates client
  """
  @spec client(String.t()) :: Tesla.Client.t()
  def client(token) do
    middleware = [
      Mailtrap.DirectResponse,
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BaseUrl, "https://sandbox.api.mailtrap.io/api"},
      {Tesla.Middleware.BearerAuth, token: token}
    ]

    Tesla.client(middleware)
  end

  @doc """
  Sends an email to sandbox inbox
  """
  @spec send(Tesla.Client.t(), Mailtrap.Email.t(), integer()) ::
          {:ok, map()} | {:error, Tesla.Env.t()}
  def send(client, email, inbox_id) do
    Tesla.post(client, "send/" <> Integer.to_string(inbox_id), email)
  end
end
