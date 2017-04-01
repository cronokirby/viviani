defmodule Viviani.Util.Docs do
  @moduledoc """
  Utility functions for accessing docs
  """
  require IEx
  def module_header(module) do
    # Won't match in the case we don't find the module, returning nil.
    with {_line, text} <- Code.get_docs(module, :moduledoc) do
      hd String.split(text, "\n")
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
    with [_|_] = docs <- Code.get_docs(module, :docs) do
      case Enum.filter(docs, &match?({{^fun, ^arity}, _, _, _, _}, &1)) do
        # Sort the results by jaro distance, take the 3 closest
        [] ->
          docs
          |> Stream.map(fn {info, _, _, _, _} -> info end)
          |> Enum.sort_by(fn {f, _} ->
            String.jaro_distance(Atom.to_string(fun), Atom.to_string(f))
          end, &>=/2)
          |> Enum.take(3)
          |> (& {:similar, &1}).()
        [{_, _, _, _spec, text}] ->
          {:ok, hd String.split(text, "\n")}
      end
    end
  end
end
