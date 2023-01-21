defmodule Bamboo.MailtrapHelper do
  @moduledoc """
  Helper module for Sandbox and Sending adapters
  """

  alias Mailtrap.Email

  def build_from_bamboo_email(bamboo_email) do
    %Email{}
    |> Email.put_from(bamboo_email.from)
    |> Email.put_to(bamboo_email.to)
    |> Email.put_cc(bamboo_email.cc)
    |> Email.put_bcc(bamboo_email.bcc)
    |> Email.put_bcc(bamboo_email.bcc)
    |> Email.put_subject(bamboo_email.subject)
    |> Email.put_text(bamboo_email.text_body)
    |> Email.put_html(bamboo_email.html_body)
    |> Email.put_headers(bamboo_email.headers)
    |> Email.put_attachments(prepare_attachments(bamboo_email.attachments))
  end

  def get_key(config, key) do
    case Map.get(config, key) do
      nil -> raise_key_error(config, key)
      key -> key
    end
  end

  defp prepare_attachments(attachments) do
    Enum.map(
      attachments,
      fn attachment ->
        mailtrap_attachment =
          Mailtrap.Email.Attachment.build(attachment.data, attachment.filename)

        Mailtrap.Email.Attachment.put_content_id(mailtrap_attachment, attachment.content_id)
      end
    )
  end

  defp raise_key_error(config, key) do
    raise ArgumentError, """
    There was no #{key} set for the adapter.

    * Here are the config options that were passed in:

    #{inspect(config)}
    """
  end
end
