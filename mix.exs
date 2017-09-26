defmodule Ebayka.Mixfile do
  use Mix.Project

  @version "0.2.1"

  def project do
    [app: :ebayka,
     version: @version,
     elixir: ">= 1.3.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),

     # Hex
     description: description(),
     package: package()]
  end

  def application do
    [applications: [:logger, :xml_builder, :sweet_xml, :httpoison]]
  end

  defp deps do
    [{:httpoison, ">= 0.11.0"},
      {:poison, ">= 2.0.0"},
      {:xml_builder, ">= 0.0.8"},
      {:sweet_xml, ">= 0.5.0"},
      {:mock, "~> 0.2.0", only: :test},
      {:ex_doc, "~> 0.14", only: :dev}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Nikolay Sverchkov"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ssnickolay/ebayka"}
    ]
  end

  defp description do
    """
    A small library to help using the eBay Trading API with Elixir
    """
  end
end
