defmodule Bamboo.MailtrapSendingAdapterTest do
  use ExUnit.Case
  import Tesla.Mock
  import Mailtrap.BambooTestHelper
  alias Bamboo.MailtrapSendingAdapter

  def api_configs, do: %{api_token: "api_token"}

  test "happy path" do
    expected_request_body =
      Jason.encode!(%{
        attachments: [],
        bcc: [%{email: "jane@example.com"}],
        cc: [%{email: "john@example.com"}],
        from: %{email: "bob@example.com"},
        headers: %{},
        html: "<strong>Thanks for joining!</strong>",
        subject: "Welcome to the app.",
        text: "Thanks for joining!",
        to: [%{email: "alice@example.com"}]
      })

    mock(fn
      %{
        method: :post,
        body: ^expected_request_body,
        headers: [
          {"content-type", "application/json"},
          {"authorization", "Bearer api_token"}
        ],
        url: "https://send.api.mailtrap.io/api/send"
      } ->
        json(%{success: true, message_ids: [1]}, status: 200)
    end)

    assert {:ok, _} = MailtrapSendingAdapter.deliver(new_email(), api_configs())
  end

  test "returns error" do
    mock(fn
      %{method: :post, url: "https://send.api.mailtrap.io/api/send"} ->
        json(%{error: "Incorrect API token"}, status: 401)
    end)

    assert {:error, _} = MailtrapSendingAdapter.deliver(new_email(), api_configs())
  end
end
