defmodule Checkov.MixProject do
  use Mix.Project

  def project do
    [
      app: :checkov,
      version: "0.4.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Checkov",
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19.1", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      maintainers: ["Brian Balser"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/bbalser/checkov"}
    ]
  end

  defp description do
    "A parameterized testing library attempting to emulate the data driven testing of the [Spock Framework](http://spockframework.org/)."
  end


end
