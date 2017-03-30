defmodule Viviani.Util.Time do
  @moduledoc """
  Provides useful functions for working with time.
  """

  @doc ~S"""
  Calculates the difference between 2 iso8601 time_strings.

  ## Examples
      iex> Time.diff("2017-03-29T21:09:25.474000+00:00",
                     "2017-03-29T21:09:25.274000+00:00")
      200
  """
  def diff(time1, time2, unit \\ :milliseconds) do
    from = fn
      %NaiveDateTime{} = x -> x
      x -> NaiveDateTime.from_iso8601!(x)
    end
    {time1, time2} = {from.(time1), from.(time2)}
    NaiveDateTime.diff(time1, time2, unit)
  end
end
