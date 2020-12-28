defmodule PelemayFpBenchmark.MixProject do
  use Mix.Project

  @version "0.1.2"

  def project do
    [
      app: :pelemay_fp_benchmark,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:benchfella, "~> 0.3.5"},
      {:pelemay_fp, "~> #{@version}"},
      {:flow, "~> 1.0.0"},
      {:pelemay, "~> 0.0.14"}
    ]
  end
end
