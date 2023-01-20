defmodule Bamboo.MailtrapSandboxAdapter do
  @moduledoc """
  Sends an email to Mailtrap Sandbox.

  ## Configuration

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.MailtrapSandboxAdapter,
        api_token: "my_api_key",
        inbox_id: "my_inbox_id"
  """

  alias Mailtrap.Email
  @behaviour Bamboo.Adapter

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
  def deliver(bamboo_email, config) do
    api_token = get_key(config, :api_token)
    inbox_id = get_key(config, :inbox_id)

    client = Mailtrap.Sandbox.client(api_token)

    email =
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

    Mailtrap.Sandbox.send(client, email, inbox_id)
    |> case do
      {:ok, response} -> {:ok, response}
      {:error, reason} -> {:error, build_api_error(inspect(reason))}
    end
  end

  defp prepare_attachments(attachments) do
    Enum.map(
      attachments,
      fn attachment ->
        mailtrap_attachment =
          Mailtrap.Email.Attachment.build(attachment.data, attachments.filename)

        Mailtrap.Email.Attachment.put_content_id(mailtrap_attachment, attachment.content_id)
      end
    )
  end

  defp get_key(config, key) do
    case Map.get(config, key) do
      nil -> raise_key_error(config, key)
      key -> key
    end
  end

  defp raise_key_error(config, key) do
    raise ArgumentError, """
    There was no #{key} set for the adapter.

    * Here are the config options that were passed in:

    #{inspect(config)}
    """
  end
end
