defmodule Mailtrap.Email do
  @moduledoc """
  Contains functions for composing email
  """

  alias Mailtrap.Email.Mailbox
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
          text: String.t() | nil,
          html: String.t() | nil,
          from: Mailbox.t(),
          to: [Mailbox.t(), ...],
          cc: [Mailbox.t(), ...],
          bcc: [Mailbox.t(), ...],
        }

  defstruct from: nil,
            to: nil,
            cc: nil,
            bcc: nil,
            subject: nil,
            text: nil,
            html: nil

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
  Puts html to the email struct

  ## Examples
    iex> Mailtrap.Email.put_html(%Mailtrap.Email{}, "<strong>Hello, Jane</strong>")
    %Mailtrap.Email{html: "<strong>Hello, Jane</strong>"}
  """
  @spec put_html(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_html(email, html) do
    %__MODULE__{email | html: html}
  end

  @doc """
  Puts from field to the email

  ## Examples
    iex> Mailtrap.Email.put_from(%Mailtrap.Email{}, "Jane", "jane.doe@example.org")
    %Mailtrap.Email{from: %Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}}
  """
  @spec put_from(__MODULE__.t(), String.t() | nil, String.t()) :: __MODULE__.t()
  def put_from(email, name, address) do
    %__MODULE__{email | from: Mailbox.build(name, address)}
  end

  @doc """
  Puts recepient or list of recepients to the email struct

  ## Examples
    iex> Mailtrap.Email.put_to(%Mailtrap.Email{}, "Jane", "jane.doe@example.org")
    %Mailtrap.Email{to: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}]}

    iex> Mailtrap.Email.put_to(%Mailtrap.Email{}, [{"Jane", "jane.doe@example.org"}, {"John", "john.doe@example.org"}])
    %Mailtrap.Email{to: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}, %Mailtrap.Email.Mailbox{name: "John", email: "john.doe@example.org"}]}
  """
  @spec put_to(__MODULE__.t(), String.t() | nil, String.t()) :: __MODULE__.t()
  @spec put_to(__MODULE__.t(), [tuple(), ...]) :: __MODULE__.t()
  def put_to(email, name, address), do: put_to(email, [{name, address}])

  def put_to(email, list) do
    mailboxes = Enum.map(list, fn {name, address} -> Mailbox.build(name, address) end)
    %__MODULE__{email | to: mailboxes}
  end

  @doc """
  Puts carbon copy recepient or list of carbon copy recepients to the email struct

  ## Examples
    iex> Mailtrap.Email.put_cc(%Mailtrap.Email{}, "Jane", "jane.doe@example.org")
    %Mailtrap.Email{cc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}]}

    iex> Mailtrap.Email.put_cc(%Mailtrap.Email{}, [{"Jane", "jane.doe@example.org"}, {"John", "john.doe@example.org"}])
    %Mailtrap.Email{cc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}, %Mailtrap.Email.Mailbox{name: "John", email: "john.doe@example.org"}]}
  """
  @spec put_cc(__MODULE__.t(), String.t() | nil, String.t()) :: __MODULE__.t()
  @spec put_cc(__MODULE__.t(), [tuple(), ...]) :: __MODULE__.t()
  def put_cc(email, name, address), do: put_cc(email, [{name, address}])

  def put_cc(email, list) do
    mailboxes = Enum.map(list, fn {name, address} -> Mailbox.build(name, address) end)
    %__MODULE__{email | cc: mailboxes}
  end

  @doc """
  Puts blind carbon copy recepient or list of blind carbon copy recepients to the email struct

  ## Examples
    iex> Mailtrap.Email.put_bcc(%Mailtrap.Email{}, "Jane", "jane.doe@example.org")
    %Mailtrap.Email{bcc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}]}

    iex> Mailtrap.Email.put_bcc(%Mailtrap.Email{}, [{"Jane", "jane.doe@example.org"}, {"John", "john.doe@example.org"}])
    %Mailtrap.Email{bcc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}, %Mailtrap.Email.Mailbox{name: "John", email: "john.doe@example.org"}]}
  """
  @spec put_bcc(__MODULE__.t(), String.t() | nil, String.t()) :: __MODULE__.t()
  @spec put_bcc(__MODULE__.t(), [tuple(), ...]) :: __MODULE__.t()
  def put_bcc(email, name, address), do: put_bcc(email, [{name, address}])

  def put_bcc(email, list) do
    mailboxes = Enum.map(list, fn {name, address} -> Mailbox.build(name, address) end)
    %__MODULE__{email | bcc: mailboxes}
  end
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
