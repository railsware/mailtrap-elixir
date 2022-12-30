defmodule MailtrapTest do
  use ExUnit.Case
  doctest Mailtrap

  test "greets the world" do
    assert Mailtrap.hello() == :world
  end
end
