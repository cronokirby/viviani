defmodule Viviani.Docs do
  @moduledoc """
  Commands for accessing docs.
  """
  use Alchemy.Cogs
  alias Alchemy.Embed
  import Embed
  alias Viviani.Util.DocUtil

  @purple_embed %Embed{color: 0x8230c3}
  @error_embed %Embed{color: 0xd42c2c}

  # Errors
  def no_module_error(module) do
    @error_embed
    |> description("It doesn't seem that #{module} is a module in Elixir or Alchemy.")
  end


  Cogs.def moduledoc(module) do
    with {:ok, header} <- DocUtil.module_header(module) do
      @purple_embed
      |> title(module)
      |> description(header)
    else
      # nil means that the string couldn't be converted to an existing module
      nil ->
        no_module_error(module)
    end
    |> Cogs.send
  end


  def docs_parser(string) do
    import String
    string
    |> reverse
    |> split(["/", "."], parts: 3)
    |> Stream.map(&reverse/1)
    |> Enum.reverse
  end

  Cogs.set_parser(:funcdoc, &Viviani.Docs.docs_parser/1)
  Cogs.def funcdoc(module, function, arity) do
    {arity, _} = Integer.parse(arity)
    case DocUtil.fun_header(module, function, arity) do
      nil ->
        no_module_error(module)
      {:ok, header} ->
        @purple_embed
        |> title("#{module}.#{function}/#{arity}")
        |> description(header)
    end
    |> Cogs.send
  end
end
