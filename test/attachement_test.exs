defmodule MailtrapAttachementTest do
  use ExUnit.Case

  doctest Mailtrap.Email.Attachment
  alias Mailtrap.Email.Attachment

  test "builds using filename and content" do
    {:ok, data} = File.read(Path.join(__DIR__, "support/invoice.pdf"))
    attachment = Attachment.build(data, "invoice.pdf")
    encoded_data = Base.encode64(data)

    assert %Attachment{
             filename: "invoice.pdf",
             content: encoded_data
           } == attachment
  end
end
