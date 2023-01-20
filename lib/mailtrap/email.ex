defmodule Mailtrap.Email do
  @moduledoc """
  Contains functions for composing email
  """

  alias Mailtrap.Email.Mailbox
  alias Mailtrap.Email.Attachment

  @type address :: {String.t(), String.t()}
  @type address_list :: nil | address | [address] | any

  @type t :: %__MODULE__{
          attachments: nil | [Attachment.t(), ...],
          bcc: nil | [Mailbox.t(), ...],
          category: nil | String.t(),
          cc: nil | [Mailbox.t(), ...],
          custom_variables: nil | map(),
          from: nil | Mailbox.t(),
          headers: nil | map(),
          html: nil | String.t(),
          subject: nil | String.t(),
          text: nil | String.t(),
          to: nil | [Mailbox.t(), ...]
        }

  defstruct attachments: nil,
            from: nil,
            to: nil,
            cc: nil,
            bcc: nil,
            subject: nil,
            text: nil,
            html: nil,
            category: nil,
            custom_variables: nil,
            headers: nil

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
  Puts category to the email struct

  ## Examples
    iex> Mailtrap.Email.put_category(%Mailtrap.Email{}, "Marketing")
    %Mailtrap.Email{category: "Marketing"}
  """
  @spec put_category(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_category(email, category) do
    %__MODULE__{email | category: category}
  end

  @doc """
  Puts custom_variables to the email struct.

  Values that are specific to the entire send that will be carried along with
  the email and its activity data.
  Total size of custom variables in JSON form must not exceed 1000 bytes.

  ## Examples
    iex> Mailtrap.Email.put_custom_variables(%Mailtrap.Email{}, %{foo: "bar"})
    %Mailtrap.Email{custom_variables: %{foo: "bar"}}
  """
  @spec put_custom_variables(__MODULE__.t(), map()) :: __MODULE__.t()
  def put_custom_variables(email, custom_variables) do
    %__MODULE__{email | custom_variables: custom_variables}
  end

  @doc """
  Puts headers to the email struct.

  An object containing key/value pairs of header names and the value to
  substitute for them. The key/value pairs must be strings. You must ensure
  these are properly encoded if they contain unicode characters. These headers
  cannot be one of the reserved headers.

  ## Examples
    iex> Mailtrap.Email.put_headers(%Mailtrap.Email{}, %{"X-Custom-Header" => "header-value"})
    %Mailtrap.Email{headers: %{"X-Custom-Header" => "header-value"}}
  """
  @spec put_headers(__MODULE__.t(), map()) :: __MODULE__.t()
  def put_headers(email, headers) do
    %__MODULE__{email | headers: headers}
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
    iex> Mailtrap.Email.put_from(%Mailtrap.Email{}, {"Jane", "jane.doe@example.org"})
    %Mailtrap.Email{from: %Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}}
  """
  @spec put_from(__MODULE__.t(), {nil | String.t(), String.t()}) :: __MODULE__.t()
  def put_from(email, {name, address}) do
    %__MODULE__{email | from: Mailbox.build(name, address)}
  end

  def put_from(email, address) do
    %__MODULE__{email | from: Mailbox.build(nil, address)}
  end

  @doc """
  Puts recepient or list of recepients to the email struct

  ## Examples
    iex> Mailtrap.Email.put_to(%Mailtrap.Email{}, {"Jane", "jane.doe@example.org"})
    %Mailtrap.Email{to: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}]}

    iex> Mailtrap.Email.put_to(%Mailtrap.Email{}, [{"Jane", "jane.doe@example.org"}, {"John", "john.doe@example.org"}])
    %Mailtrap.Email{to: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}, %Mailtrap.Email.Mailbox{name: "John", email: "john.doe@example.org"}]}
  """
  @spec put_to(__MODULE__.t(), {String.t() | nil, String.t()}) :: __MODULE__.t()
  @spec put_to(__MODULE__.t(), [tuple(), ...]) :: __MODULE__.t()
  def put_to(email, {name, address}), do: put_to(email, [{name, address}])

  def put_to(email, list) do
    mailboxes = Enum.map(list, fn {name, address} -> Mailbox.build(name, address) end)
    %__MODULE__{email | to: mailboxes}
  end

  @doc """
  Puts carbon copy recepient or list of carbon copy recepients to the email struct

  ## Examples
    iex> Mailtrap.Email.put_cc(%Mailtrap.Email{}, {"Jane", "jane.doe@example.org"})
    %Mailtrap.Email{cc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}]}

    iex> Mailtrap.Email.put_cc(%Mailtrap.Email{}, [{"Jane", "jane.doe@example.org"}, {"John", "john.doe@example.org"}])
    %Mailtrap.Email{cc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}, %Mailtrap.Email.Mailbox{name: "John", email: "john.doe@example.org"}]}
  """
  @spec put_cc(__MODULE__.t(), {String.t() | nil, String.t()}) :: __MODULE__.t()
  @spec put_cc(__MODULE__.t(), [tuple(), ...]) :: __MODULE__.t()
  def put_cc(email, {name, address}), do: put_cc(email, [{name, address}])

  def put_cc(email, list) do
    mailboxes = Enum.map(list, fn {name, address} -> Mailbox.build(name, address) end)
    %__MODULE__{email | cc: mailboxes}
  end

  @doc """
  Puts blind carbon copy recepient or list of blind carbon copy recepients to the email struct

  ## Examples
    iex> Mailtrap.Email.put_bcc(%Mailtrap.Email{}, {"Jane", "jane.doe@example.org"})
    %Mailtrap.Email{bcc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}]}

    iex> Mailtrap.Email.put_bcc(%Mailtrap.Email{}, [{"Jane", "jane.doe@example.org"}, {"John", "john.doe@example.org"}])
    %Mailtrap.Email{bcc: [%Mailtrap.Email.Mailbox{name: "Jane", email: "jane.doe@example.org"}, %Mailtrap.Email.Mailbox{name: "John", email: "john.doe@example.org"}]}
  """
  @spec put_bcc(__MODULE__.t(), {String.t() | nil, String.t()}) :: __MODULE__.t()
  @spec put_bcc(__MODULE__.t(), [tuple(), ...]) :: __MODULE__.t()
  def put_bcc(email, {name, address}), do: put_bcc(email, [{name, address}])

  def put_bcc(email, list) do
    mailboxes = Enum.map(list, fn {name, address} -> Mailbox.build(name, address) end)
    %__MODULE__{email | bcc: mailboxes}
  end

  @doc """
  Puts attachments struct to the email struct

  ## Examples
    iex> attachment = Mailtrap.Email.Attachment.build("content", "filename")
    iex> Mailtrap.Email.put_attachments(%Mailtrap.Email{}, [attachment])
    %Mailtrap.Email{
      attachments: [
        %Mailtrap.Email.Attachment{
          filename: "filename",
          content: "Y29udGVudA=="
        }
      ]
    }
  """
  @spec put_attachments(__MODULE__.t(), [Attachment.t(), ...]) :: __MODULE__.t()
  def put_attachments(email, attachments) do
    %__MODULE__{email | attachments: attachments}
  end
end

defimpl Jason.Encoder, for: [Mailtrap.Email, Mailtrap.Email.Mailbox, Mailtrap.Email.Attachment] do
  def encode(struct, opts) do
    struct
    |> Map.from_struct()
    |> Enum.map(& &1)
    |> Enum.filter(fn {_k, v} -> !is_nil(v) end)
    |> Jason.Encode.keyword(opts)
  end
end
