# Mailtrap

[![Elixir CI](https://github.com/kalys/elixir-mailtrap/actions/workflows/elixir.yml/badge.svg)](https://github.com/kalys/elixir-mailtrap/actions/workflows/elixir.yml)
[![Module Version](https://img.shields.io/hexpm/v/mailtrap.svg)](https://hex.pm/packages/mailtrap)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/mailtrap/)
[![Total Download](https://img.shields.io/hexpm/dt/mailtrap.svg)](https://hex.pm/packages/mailtrap)
[![License](https://img.shields.io/hexpm/l/mailtrap.svg)](https://github.com/kalys/elixir-mailtrap/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/kalys/elixir-mailtrap.svg)](https://github.com/kalys/elixir-mailtrap/commits/master)

Mailtrap API client
Bamboo adapters for Mailtrap Sandbox and Mailtrap Sending APIs

## Installation

```elixir
def deps do
  [
    {:mailtrap, "~> 0.1.0"}
  ]
end
```

## Configuration

For Mailtrap Sandbox Bamboo adapter

```elixir
config :test_mailtrap, TestMailtrap.Mailer,
  adapter: Bamboo.MailtrapSandboxAdapter,
  api_token: "PASTE TOKEN HERE",
  inbox_id: 111 # replace with your inbox id
```

For Mailtrap Sending Bamboo adapter

```elixir
config :test_mailtrap, TestMailtrap.Mailer,
  adapter: Bamboo.MailtrapSendingAdapter,
  api_token: "PASTE TOKEN HERE"
```

## Usage

Mailtrap API

```elixir
  client = Mailtrap.client("PASTE TOKEN HERE")
  accounts = Mailtrap.get(client, "accounts")
  # or
  Mailtrap.delete(client, "accounts/" <> account_id <> "/account_accesses/" <> account_access_id)
```

Sending to Mailtrap Sandbox API

```elixir
client = Mailtrap.Sandbox.client("PASTE TOKEN HERE")
email = (%Mailtrap.Email{}
  |> Mailtrap.Email.put_from({"From name", "from@example.com"})
  |> Mailtrap.Email.put_to({"Recepient", "recepient@example.com"})
  |> Mailtrap.Email.put_subject("Hi there")
  |> Mailtrap.Email.put_text("General Kenobi"))
Mailtrap.Sandbox.send(client, email, 111) # replace 111 with your inbox id
```

Sending via Mailtrap Sending API

```elixir
client = Mailtrap.Sending.client("PASTE TOKEN HERE")
email = (%Mailtrap.Email{}
  |> Mailtrap.Email.put_from({"From name", "from@example.com"})
  |> Mailtrap.Email.put_to({"Recepient", "recepient@example.com"})
  |> Mailtrap.Email.put_subject("Hi there")
  |> Mailtrap.Email.put_text("General Kenobi"))
Mailtrap.Sending.send(client, email)
```

### Bamboo adapter

```elixir
# mailer module
defmodule TestMailtrap.Mailer do
  use Bamboo.Mailer, otp_app: :test_mailtrap
end

# generate email
def welcome_email(subject \\ "Hi there", friendly_name \\ "Recepient", to \\ "recepient@example.com") do
  new_email(
    to: {friendly_name, to},
    from: {"From", "from@example.com"},
    subject: subject,
    html_body: "<strong>Thanks for joining!</strong>",
    text_body: "Thanks for joining!"
  )
end

# send
welcome_email() |> TestMailtrap.Mailer.deliver_now()
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/mailtrap>.

## Copyright and License

Copyright (c) 2023 Kalys Osmonov

This library is released under the MIT License. See the [LICENSE.md](./LICENSE.md) file.
