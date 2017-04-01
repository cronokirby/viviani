defmodule Viviani.Util.Docs do
  @moduledoc """
  Utility functions for accessing docs
  """

  def module_header(module) do
    # Won't match in the case we don't find the module, returning nil.
    with {_line, text} <- Code.get_docs(module, :moduledoc) do
      hd String.split(text, "\n")
    end
  end
end
