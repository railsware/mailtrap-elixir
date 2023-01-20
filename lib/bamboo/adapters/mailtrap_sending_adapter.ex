defmodule Bamboo.MailtrapSendingAdapter do
  @moduledoc """
  Sends an email to Mailtrap Sending.
  """

  @behaviour Bamboo.Adapter

  alias Mailtrap.Email
  alias Mailtrap.Email.Attachment
  import Bamboo.ApiError

  @doc """
  Implements Bamboo.Adapter callback
  """
  @impl Bamboo.Adapter
  def supports_attachments?, do: true

  @doc """
  Implements Bamboo.Adapter callback
  """
  @impl Bamboo.Adapter
  def handle_config(config) do
    config
  end

  @doc """
  Implements Bamboo.Adapter callback
  """
  @impl Bamboo.Adapter
  def deliver(email, _config) do
    %Email{}
    |> Email.put_from(email.from)
    |> Email.put_to(email.to)
    |> Email.put_cc(email.cc)
    |> Email.put_bcc(email.bcc)
    |> Email.put_bcc(email.bcc)
    |> Email.put_subject(email.subject)
    |> Email.put_text(email.text_body)
    |> Email.put_html(email.html_body)
    |> Email.put_headers(email.headers)
    |> Email.put_attachments(prepare_attachments(email.attachments))
    |> Mailtrap.Sending.send()
  end

  defp prepare_attachments(attachments) do
    Enum.map(
      attachments,
      fn attachment ->
        mailtrap_attachment = Attachment.build(attachment.data, attachments.filename)
        Attachment.put_content_id(mailtrap_attachment, attachment.content_id)
      end
    )
  end
end
