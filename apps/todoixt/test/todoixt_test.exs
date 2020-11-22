defmodule TodoixtTest do
  use ExUnit.Case
  doctest Todoixt

  test "greets the world" do
    assert Todoixt.hello() == :world
  end
end
