defmodule Viviani.Util.TimeTest do
  use ExUnit.Case
  alias Viviani.Util.Time


  test "Standard Timediffs" do
    dt = "2017-03-29T21:09:25.274000+00:00"
    dt2 = "2017-03-29T21:09:26.274000+00:00"
    diff = Time.diff(dt, dt2)
    assert diff == -1000
    assert diff == (Time.diff(dt, dt2, :seconds) * 1000)
  end
end
