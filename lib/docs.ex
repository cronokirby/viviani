defmodule Viviani.Docs do
  @moduledoc """
  Commands for accessing docs.
  """
  use Alchemy.Cogs
  alias Alchemy.Embed
  import Embed
  alias Viviani.Util.Docs


  def docs_parser(string) do
    import String
    string
    |> reverse
    |> split(["/", "."], parts: 3)
    |> Stream.map(&reverse/1)
    |> Enum.reverse
  end


  @purple_embed %Embed{color: 0x8230c3}
  @error_embed %Embed{color: 0xd42c2c}

  Cogs.def moduledoc(module) do
    with {:ok, header} <- Docs.module_header(module) do
      @purple_embed
      |> title(module)
      |> description(header)
    else
      nil ->
        @error_embed
        |> description("It doesn't seem that #{module} is a module in Elixir " <>
                       "or Alchemy.")
    end
    |> Cogs.send
  end

end
