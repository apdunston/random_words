defmodule RandomWords.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :random_words,
      version: "1.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
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
      {:nimble_csv, "~> 0.7"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
    ]
  end

  defp description() do
    "Provides random words from a list of 5,000 most common American English words. Can break them down into parts-of-speech. Fun for party tricks, example strings, and random names."
  end

  defp package() do
    [
      maintainers: ["Adrian P. Dunston"],
      licenses: ["MIT", "Word list owned and provided by https://www.wordfrequency.info/."],
      links: %{"GitHub" => "https://github.com/apdunston/random_words"}
    ]
  end
end
