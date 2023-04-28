# TODO rename MyAPP
defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "1.0.0",
      deps: deps(),
      elixirc_paths: elixirc_paths()
    ]
  end

  defp deps do
    [
      {:csv, "3.0.5"},
      {:dialyxir, "1.3.0", only: [:dev], runtime: false}
    ]
  end

  defp elixirc_paths do
    if Mix.env() == :test do
      ["lib", "test/support", "test/dialyzer"]
    else
      ["lib"]
    end
  end
end
