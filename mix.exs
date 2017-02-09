defmodule Ebayka.Mixfile do
  use Mix.Project

  def project do
    [app: :ebayka,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :xml_builder, :sweet_xml, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.9.0"},
      {:poison, "~> 2.0"},
      {:xml_builder, "~> 0.0.8"},
      {:sweet_xml, "~> 0.5"},
      {:mock, "~> 0.2.0", only: :test}]
  end
end
