defmodule PhoneVerification.MixProject do
  use Mix.Project

  def project do
    [
      app: :phone_verification,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["Apache 2"],
      links: %{
        GitHub: "https://github.com/fuelen/phone_verification"
      }
    ]
  end

  defp description do
    """
    The package allows you to verify phone number using simple API.
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
