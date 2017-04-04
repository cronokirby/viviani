defmodule Viviani.Util.DocUtilTest do
  use ExUnit.Case
  alias Viviani.Util.DocUtil

  @genserver_header "A behaviour module for implementing the " <>
                    "server of a client-server relation."
  @alchemy_cache "This module provides a handful of useful functions "<>
                 "to interact with the cache."

  test "Module headers should be accessible, or nil" do
    assert DocUtil.module_header("GenServer") == {:ok, @genserver_header}
    assert DocUtil.module_header("Alchemy.Cache") == {:ok, @alchemy_cache}
    assert DocUtil.module_header("FOFOFOFOFOFO") == nil
  end

  @enum_each "Invokes the given `fun` for each item in the enumerable."
  @cache_emoji "Retrieves a custom emoji by id in a guild."

  test "Function headers should be accessible" do
    assert DocUtil.fun_header("Alchemy.Cache", "emoji", 2) == {:ok, @cache_emoji}
    assert DocUtil.fun_header("Enum", "each", 2) == {:ok, @enum_each}
  end

  test "Function headers should yield suggestions" do
    assert {:similar, [_, _, _]} = DocUtil.fun_header("Alchemy.Cache", "mmeber", 2)
    {:similar, suggestions} = DocUtil.fun_header("Enum", "cuont", 1)
    assert {:count, 2} in suggestions
  end

  @enum_all "https://hexdocs.pm/elixir/1.4.2/Enum.html#all?/2"
  @client_start "https://hexdocs.pm/discord_alchemy/0.2.2/Alchemy.Client.html#start/2"

  test "Links should be available for alchemy and elixir" do
    assert DocUtil.link("Enum", "all?", 2) == @enum_all
    assert DocUtil.link("Alchemy.Client", "start", 2) == @client_start
  end

  test "Links should work for just a module" do
    assert DocUtil.link("Enum") == "https://hexdocs.pm/elixir/1.4.2/Enum.html"
  end
end
