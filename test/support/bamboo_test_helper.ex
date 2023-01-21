defmodule Mailtrap.BambooTestHelper do
  @moduledoc """
  Test helper module
  """

  alias Bamboo.{Email, Mailer}

  @doc false
  def new_email(to \\ "alice@example.com", subject \\ "Welcome to the app.") do
    Email.new_email(
      to: to,
      from: "bob@example.com",
      cc: "john@example.com",
      bcc: "jane@example.com",
      subject: subject,
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
    |> Mailer.normalize_addresses()
  end
end
