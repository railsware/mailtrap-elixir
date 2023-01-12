defmodule Mailtrap.Email do
  @moduledoc """
  Contains functions for composing email
  """

  # @type t :: %__MODULE__{
  #         FromEmailAddress: String.t() | nil,
  #         FromEmailAddressIdentityArn: String.t() | nil,
  #         ConfigurationSetName: String.t() | nil,
  #         Destination: Destination.t(),
  #         ReplyToAddresses: [Bamboo.Email.address()],
  #         Content: Content.t(),
  #         FeedbackForwardingEmailAddress: String.t() | nil,
  #         FeedbackForwardingEmailAddressIdentityArn: String.t() | nil,
  #         ListManagementOptions: map() | nil,
  #         EmailTags: nonempty_list(map()) | nil
  #       }
  @type t :: %__MODULE__{
          subject: String.t(),
          text: String.t() | nil
        }

  defstruct from: nil,
            to: [],
            subject: nil,
            text: nil

  @doc """
  Puts subject to the email struct

  ## Examples
    iex> Mailtrap.Email.put_subject(%Mailtrap.Email{}, "Hello")
    %Mailtrap.Email{subject: "Hello"}
  """
  @spec put_subject(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_subject(email, subject), do: %__MODULE__{email | subject: subject}

  @doc """
  Puts text to the email struct

  ## Examples
    iex> Mailtrap.Email.put_text(%Mailtrap.Email{}, "Hello, Jane")
    %Mailtrap.Email{text: "Hello, Jane"}
  """
  @spec put_text(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_text(email, text) do
    %__MODULE__{email | text: text}
  end

  @doc """
  Puts from field to the email

  ## Examples
    iex> Mailtrap.Email.put_from(%Mailtrap.Email{}, "Jane", "jane.doe@example.org")
    %Mailtrap.Email{from: %Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}}
  """
  @spec put_from(__MODULE__.t(), String.t() | nil, String.t()) :: __MODULE__.t()
  def put_from(email, name, address) do
    %__MODULE__{email | from: Mailtrap.Email.Mailbox.build(name, address)}
  end

  def put_to(email, to) do
    %__MODULE__{email | to: to}
  end

  # ConfigurationSetName: nil,
  # to: %Destination{},
  # ReplyToAddresses: [],
  # Content: %Content{},
  # FeedbackForwardingEmailAddress: nil,
  # FeedbackForwardingEmailAddressIdentityArn: nil,
  # ListManagementOptions: nil,
  # EmailTags: nil
end

defimpl Jason.Encoder, for: [Mailtrap.Email] do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.map(& &1)
    |> Enum.filter(fn {_k, v} -> !is_nil(v) end)
    |> Jason.Encode.keyword(opts)
  end
end
