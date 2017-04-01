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

  def fun_header(module, fun, arity) do
    with [_|_] = docs <- Code.get_docs(module, :docs) do
      case Enum.filter(docs, &match?({{^fun, ^arity}, _, _, _, _}, &1)) do
        # conforming to the previous return
        [] -> nil
        [{_, _, _, _spec, text}] ->
          hd String.split(text, "\n")
      end
    end
  end
end
