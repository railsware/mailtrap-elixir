defmodule Mailtrap.Factory do
  use ExMachina

  def account_access_factory(attrs) do
    account_access = %{
      id: sequence_id(:account_access),
      specifier_type: "User",
      resources: [
        %{
          resource_type: "account",
          resource_id: sequence_id(:resource),
          access_level: 1000
        }
      ],
      specifier: %{
        id: sequence_id(:specifier),
        email: sequence(:email, &"user#{&1}@example.com"),
        name: "John Doe"
      },
      permissions: %{
        can_read: false,
        can_update: false,
        can_destroy: false,
        can_leave: false
      }
    }

    account_access |> merge_attributes(attrs)
  end

  defp sequence_id(name) do
    sequence(name, &"#{&1}", start_at: 100) |> String.to_integer()
  end
end
