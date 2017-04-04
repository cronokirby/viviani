defmodule Viviani.Util.DocUtil do
  @moduledoc """
  Utility functions for accessing docs
  """

  @doc """
  Gets the doc header for a module.
  """
  def module_header(module) do
    # We catch the inability to convert to an existing atom -> no such module
    try do
      module = ("Elixir." <> module) |> String.to_existing_atom
      {_line, text} = Code.get_docs(module, :moduledoc)
      {:ok, hd String.split(text, "\n")}
    rescue
      _e in ArgumentError -> nil
    end
  end

  @doc """
  Gets the first line of a function doc.

  ## Returns
  - `nil`
    The module doesn't exist.
  - `{:similar, suggestions}`
    Returns a list of `{function, arity}` pairs of closely matching function names.
  - `{:ok, text}`
    This is a succesful header.
  """
  def fun_header(module, fun, arity) do
    try do
      module = "Elixir." <> module
      docs = Code.get_docs(String.to_existing_atom(module), :docs)
      case Enum.filter(docs, fn {{f, a}, _, _, _, _} ->
        {Atom.to_string(f), a} == {fun, arity}
      end) do
        # Sort the results by jaro distance, take the 3 closest
        [] ->
          {:similar, find_similar(docs, fun)}
        [{_, _, _, _spec, text}] ->
          {:ok, hd String.split(text, "\n")}
      end
    rescue
      _e in ArgumentError -> nil
    end
  end

  defp find_similar(docs, fun, amount \\ 3) do
    docs
    |> Stream.map(fn {info, _, _, _, _} -> info end)
    |> Enum.sort_by(fn {f, _} ->
      String.jaro_distance(fun, Atom.to_string(f))
    end, &>=/2)
    |> Enum.take(amount)
  end

  @hex_root "https://hexdocs.pm/"
  @elixir_root @hex_root <> "elixir/1.4.2/"
  @alchemy_root @hex_root <> "discord_alchemy/0.2.2/"

  def link(module, func, arity) do
    root = case module do
      "Alchemy" <> _rest -> @alchemy_root
      _else -> @elixir_root
    end
    root <> "#{module}.html\##{func}/#{arity}"
  end
end
