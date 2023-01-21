defmodule Bamboo.MailtrapSandboxAdapter do
  @moduledoc """
  Sends an email to Mailtrap Sandbox.

  ## Configuration

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.MailtrapSandboxAdapter,
        api_token: "my_api_key",
        inbox_id: "my_inbox_id"
  """

  @behaviour Bamboo.Adapter

  import Bamboo.ApiError
  import Bamboo.MailtrapHelper

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
    email = build_from_bamboo_email(bamboo_email)

    case Mailtrap.Sandbox.send(client, email, inbox_id) do
      {:ok, response} -> {:ok, response}
      {:error, reason} -> {:error, build_api_error(inspect(reason))}
    end
  end
end
