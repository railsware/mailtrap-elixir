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

  defstruct from: nil,
            to: [],
            subject: nil,
            text: nil

  def put_subject(email, subject), do: %__MODULE__{email | subject: subject}

  def put_from(email, from) do
    %__MODULE__{email | from: from}
  end

  def put_to(email, to) do
    %__MODULE__{email | to: to}
  end

  def put_text(email, text) do
    %__MODULE__{email | text: text}
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
