defmodule Viviani do
  @moduledoc """
  This is the main entry point for the bot.

  Because of this, we use this module as an `Application`, and register
  it in the `mix.exs` file.
  """
  use Application
  alias Alchemy.Client

  # If this fails we won't be able to start the bot anyways, so the bang makes sense
  @token Application.fetch_env!(:viviani, :token)

  @doc """
  This is the callback for `Application`, and what starts up our bot.
  """
  def start(_type, _args) do
    run = Client.start(@token)
    load_modules()
    # We supply this to satisfy the application callback
    run
  end

  # This loads and wires up all the commands and event modules we want to start with
  defp load_modules do
   use Viviani.Basic
   use Viviani.Statistics
   use Viviani.Docs
  end
end
