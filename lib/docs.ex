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
      |> url(DocUtil.link(module))
      |> description(header)
    else
      # nil means that the string couldn't be converted to an existing module
      nil ->
        no_module_error(module)
    end
    |> Embed.send
  end


  def docs_parser(string) do
    import String
    string
    |> reverse
    |> split(["/", "."], parts: 3)
    |> Stream.map(&reverse/1)
    |> Enum.reverse
  end

  Cogs.set_parser(:fundoc, &Viviani.Docs.docs_parser/1)
  Cogs.def fundoc(module, function, arity) do
    func_format = fn m, f, a -> "#{m}.#{f}/#{a}" end
    {arity, _} = Integer.parse(arity)
    case DocUtil.fun_header(module, function, arity) do
      nil ->
        no_module_error(module)
      {:similar, list} ->
        %Embed{color: 0x1f95c1}
        |> description("Failed to find the function "<>
                       "`#{func_format.(module, function, arity)}`.")
        |> field("Perhaps you meant one of:", Enum.map_join(list, "\n", fn {f, a} ->
          "`" <> func_format.(module, f, a) <> "`"
        end))
      {:ok, header} ->
        @purple_embed
        |> title(func_format.(module, function, arity))
        |> url(DocUtil.link(module, function, arity))
        |> description(header)
    end
    |> Embed.send
  end
end
