defmodule TestElixir.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      elixirc_paths: elixirc_paths(),
      version: "1.0.0"
    ]
  end

  def application do
    [
      extra_applications: [:eex, :logger],
      mod: {Main.Application, []}
    ]
  end

  defp aliases do
    [
      c: "compile",
      test: ["test --cover", "dialyzer"]
    ]
  end

  defp deps do
    [
      {:csv, "3.0.5"},
      {:geocalc, "0.8.5"},
      {:plug_cowboy, "2.6.1"},
      {:dialyxir, "1.3.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp elixirc_paths do
    ["lib"]
  end
end
