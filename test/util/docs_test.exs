defmodule Viviani.Util.DocsTest do
  use ExUnit.Case
  alias Viviani.Util.Docs

  @genserver_header "A behaviour module for implementing the " <>
                    "server of a client-server relation."

  @alchemy_cache "This module provides a handful of useful functions "<>
                 "to interact with the cache."

  test "Module headers should be accessible, or nil" do
    assert Docs.module_header(GenServer) == @genserver_header
    assert Docs.module_header(Alchemy.Cache) == @alchemy_cache
    assert Docs.module_header(FOFOFOFOFOFO) == nil
  end

  @enum_each "Invokes the given `fun` for each item in the enumerable."

  @cache_emoji "Retrieves a custom emoji by id in a guild."

  test "Function headers should be accessible" do
    assert Docs.fun_header(Alchemy.Cache, :emoji, 2) == {:ok, @cache_emoji}
    assert Docs.fun_header(Enum, :each, 2) == {:ok, @enum_each}
  end

  test "Function headers should yield suggestions" do
    assert {:similar, [_, _, _]} = Docs.fun_header(Alchemy.Cache, :mmeber, 2)
    {:similar, suggestions} = Docs.fun_header(Enum, :cuont, 1)
    assert {:count, 2} in suggestions
  end
end
