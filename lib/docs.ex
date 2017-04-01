defmodule Viviani.Docs do
  @moduledoc """
  Commands for accessing docs.
  """
  use Alchemy.Cogs
  alias Viviani.Util.Docs


  def docs_parser(string) do
    import String
    string
    |> reverse
    |> split(["/", "."], parts: 3)
    |> Stream.map(&reverse/1)
    |> Enum.reverse
  end

end
