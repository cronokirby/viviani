defmodule Viviani.Mixfile do
  use Mix.Project

  def project do
    [app: :viviani,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end


  def application do
    [mod: {Viviani, []}]
  end

  defp aliases do
    [test: "test --no-start"]
  end

  defp deps do
    [{:alchemy, git: "https://github.com/cronokirby/alchemy.git"}]
  end
end
