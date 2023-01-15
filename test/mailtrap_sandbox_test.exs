defmodule MailtrapSandboxTest do
  use ExUnit.Case
  # import Mailtrap.Factory
  import Tesla.Mock
  alias Mailtrap.Email

  test "authentication error" do
    mock(fn
      %{method: :post, url: "https://sandbox.api.mailtrap.io/api/send/111"} ->
        json(%{error: "Incorrect API token"}, status: 401)
    end)

    message = %Mailtrap.Email{}
    assert {:error, %Tesla.Env{status: 401, body: body}} = Mailtrap.Sandbox.send(message, 111)
    assert %{"error" => "Incorrect API token"} == body
  end

  test "sending" do
    body =
      Jason.encode!(%{
        subject: "Hello",
        from: %{email: "john.doe@example.com", name: "John Doe"},
        html: "<strong>Hello</strong>",
        text: "Hello",
        to: [%{email: "jane.doe@example.com", name: "Jane Doe"}],
        cc: [%{email: "alice@example.com", name: "Alice"}]
      })

    mock(fn
      %{method: :post, url: "https://sandbox.api.mailtrap.io/api/send/111", body: ^body} ->
        json(%{success: true, message_ids: ["1", "2"]})
    end)

    response =
      %Email{}
      |> Email.put_subject("Hello")
      |> Email.put_from("John Doe", "john.doe@example.com")
      |> Email.put_to("Jane Doe", "jane.doe@example.com")
      |> Email.put_cc("Alice", "alice@example.com")
      |> Email.put_text("Hello")
      |> Email.put_html("<strong>Hello</strong>")
      |> Mailtrap.Sandbox.send(111)

    assert {:ok, %{"message_ids" => ["1", "2"], "success" => true}} = response
  end
end
