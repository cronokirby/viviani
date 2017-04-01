defmodule Viviani.Util.Docs do
  @moduledoc """
  Utility functions for accessing docs
  """
  require IEx
  def module_header(module) do
    # Won't match in the case we don't find the module, returning nil.
    try do
      module = ("Elixir." <> module) |> String.to_existing_atom
      {_line, text} = Code.get_docs(module, :moduledoc)
      hd String.split(text, "\n")
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
          docs
          |> Stream.map(fn {info, _, _, _, _} -> info end)
          |> Enum.sort_by(fn {f, _} ->
            String.jaro_distance(fun, Atom.to_string(f))
          end, &>=/2)
          |> Enum.take(3)
          |> (& {:similar, &1}).()
        [{_, _, _, _spec, text}] ->
          {:ok, hd String.split(text, "\n")}
      end
    rescue
      _e in ArgumentError -> nil
    end
  end
end
