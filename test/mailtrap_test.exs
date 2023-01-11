defmodule MailtrapTest do
  use ExUnit.Case
  import Tesla.Mock

  test "authentication error" do
    mock(fn
      %{method: :get, url: "https://mailtrap.io/api/accounts"} ->
        json(%{error: "Incorrect API token"}, status: 401)
    end)

    assert {:error, %Tesla.Env{status: 401, body: body}} = Mailtrap.get("accounts")
    assert %{"error" => "Incorrect API token"} == body
  end

  test "list accounts" do
    mock(fn
      %{method: :get, url: "https://mailtrap.io/api/accounts"} ->
        json([%{"access_levels" => [100], "id" => 11_111, "name" => "John Doe"}])
    end)

    assert {:ok, [%{"name" => "John Doe", "id" => 11_111, "access_levels" => [100]}]} =
             Mailtrap.get("accounts")
  end
end
