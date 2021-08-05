defmodule JViewer.MixProject do
  use Mix.Project

  def project do
    [
      app: :j_viewer,
      version: "0.1.1",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "JViewer",
      source_url: "https://github.com/mtvch/j-viewer",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
    ]
  end

  defp description() do
    "JViewer is an excellent way to declaratively represent elixir data in a JSON encodable format."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mtvch/j-viewer"}
    ]
  end
end
