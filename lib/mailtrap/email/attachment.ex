defmodule Mailtrap.Email.Attachment do
  @moduledoc """
  Attachment  struct
  """

  @type t :: %__MODULE__{
          filename: String.t(),
          content: String.t(),
          type: String.t() | nil,
          disposition: String.t() | nil,
          content_id: String.t() | nil
        }

  defstruct filename: nil,
            content: nil,
            type: nil,
            disposition: nil,
            content_id: nil

  @doc """
  Builds Attachment struct
  """
  @spec build(binary(), String.t()) :: __MODULE__.t()
  def build(content, filename) do
    %__MODULE__{filename: filename, content: Base.encode64(content)}
  end

  @doc """
  Puts type to the attachment struct

  ## Examples
    iex> attachment = Mailtrap.Email.Attachment.build("content", "filename")
    iex> Mailtrap.Email.Attachment.put_type(attachment, "text/plain")
    %Mailtrap.Email.Attachment{
      type: "text/plain",
      filename: "filename",
      content: "Y29udGVudA=="
    }
  """
  @spec put_type(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_type(attachment, type), do: %__MODULE__{attachment | type: type}

  @doc """
  Puts disposition to the attachment struct.

  ## Examples
    iex> attachment = Mailtrap.Email.Attachment.build("content", "filename")
    iex> Mailtrap.Email.Attachment.put_disposition(attachment, "inline")
    %Mailtrap.Email.Attachment{
      disposition: "inline",
      filename: "filename",
      content: "Y29udGVudA=="
    }
  """
  @spec put_disposition(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_disposition(attachment, disposition) do
    %__MODULE__{attachment | disposition: disposition}
  end

  @doc """
  Puts content_id to the attachment struct.

  ## Examples
    iex> attachment = Mailtrap.Email.Attachment.build("content", "filename")
    iex> Mailtrap.Email.Attachment.put_content_id(attachment, "abcdef")
    %Mailtrap.Email.Attachment{
      content_id: "abcdef",
      filename: "filename",
      content: "Y29udGVudA=="
    }
  """
  @spec put_content_id(__MODULE__.t(), String.t()) :: __MODULE__.t()
  def put_content_id(attachment, content_id) do
    %__MODULE__{attachment | content_id: content_id}
  end
end
