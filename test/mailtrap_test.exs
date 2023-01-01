defmodule MailtrapTest do
  use ExUnit.Case
  import Mailtrap.Factory
  import Tesla.Mock

  doctest Mailtrap

  test "authentication error" do
    mock(fn
      %{method: :get, url: "https://mailtrap.io/api/accounts"} ->
        json(%{error: "Incorrect API token"}, status: 401)
    end)

    assert {:error, %Tesla.Env{status: 401, body: body}} = Mailtrap.accounts()
    assert %{"error" => "Incorrect API token"} == body
  end

  test "list accounts" do
    mock(fn
      %{method: :get, url: "https://mailtrap.io/api/accounts"} ->
        json([%{"access_levels" => [100], "id" => 11_111, "name" => "John Doe"}])
    end)

    assert {:ok, [%{"name" => "John Doe", "id" => 11_111, "access_levels" => [100]}]} =
             Mailtrap.accounts()
  end

  test "list account accesses" do
    account_accesses = [
      build(:account_access, %{id: 100}),
      build(:account_access, %{id: 101, specifier_type: "Invite"})
    ]

    mock(fn
      %{method: :get, url: "https://mailtrap.io/api/accounts/12345/account_accesses"} ->
        json(account_accesses)
    end)

    assert {:ok, account_accesses} = Mailtrap.account_accesses(12_345)

    assert [
             %{
               "id" => 100,
               "specifier_type" => "User"
             },
             %{
               "id" => 101,
               "specifier_type" => "Invite"
             }
           ] = account_accesses
  end

  test "filter account accesses" do
    account_accesses = [
      build(:account_access, %{id: 100}),
      build(:account_access, %{id: 101, specifier_type: "Invite"})
    ]

    mock(fn
      %{
        method: :get,
        url: "https://mailtrap.io/api/accounts/12345/account_accesses",
        query: [
          project_ids: [10, 11, 12]
        ]
      } ->
        json(account_accesses)
    end)

    assert {:ok, account_accesses} = Mailtrap.account_accesses(12_345, project_ids: [10, 11, 12])

    assert [
             %{
               "id" => 100,
               "specifier_type" => "User"
             },
             %{
               "id" => 101,
               "specifier_type" => "Invite"
             }
           ] = account_accesses
  end

  # test "delete account access" do
  #   mock(fn
  #     %{method: :delete, url: "https://mailtrap.io/api/accounts/12345/account_accesses/100"} ->
  #       json(account_accesses)
  #   end)

  # end
end
