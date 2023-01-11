defmodule Mailtrap.DirectResponse do
  @moduledoc """
  Middleware for returing json body instead of Tesla.Env response
  """
  @behaviour Tesla.Middleware

  def call(env, next, _options) do
    env
    |> Tesla.run(next)
    |> handle_response()
  end

  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({_, response}), do: {:error, response}
end
