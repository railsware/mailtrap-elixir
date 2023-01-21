defmodule Bamboo.MailtrapSendingAdapter do
  @moduledoc """
  Sends an email to Mailtrap Sending.

  ## Configuration

      config :my_app, MyApp.Mailer,
        adapter: Bamboo.MailtrapSendingAdapter,
        api_token: "my_api_key"
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

    client = Mailtrap.Sending.client(api_token)
    email = build_from_bamboo_email(bamboo_email)

    case Mailtrap.Sending.send(client, email) do
      {:ok, response} -> {:ok, response}
      {:error, reason} -> {:error, build_api_error(inspect(reason))}
    end
  end
end
