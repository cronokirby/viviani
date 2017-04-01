defmodule Viviani.DocCommandTest do
  use ExUnit.Case
  alias Viviani.Docs


  test "Parsing should work correctly" do
    assert Docs.docs_parser("String.split/2") == ["String", "split", "2"]
    assert Docs.docs_parser("Alchemy.Client.start/10") ==
           ["Alchemy.Client", "start", "10"]
  end
end
