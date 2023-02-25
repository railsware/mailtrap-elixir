defmodule Mailtrap.MixProject do
  use Mix.Project

  def project do
    [
      app: :mailtrap,
      version: "0.1.2",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.5"},
      {:hackney, "~> 1.18"},
      {:jason, ">= 1.0.0"},
      {:bamboo, "~> 2.0"},
      {:ex_machina, "~> 2.7", only: :test},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      description: "Official mailtrap.io API clients. Bamboo adapters for mailtrap.io Sandbox and Sending",
      maintainers: ["Railsware Products Studio LLC <support@mailtrap.io>"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/railsware/mailtrap-elixir"}
    ]
  end

  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/support"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths(), do: ["lib"]
end
