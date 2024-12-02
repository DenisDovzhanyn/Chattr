defmodule WebSocketConnectionsAppTest do
  use ExUnit.Case
  doctest WebSocketConnectionsApp

  test "greets the world" do
    assert WebSocketConnectionsApp.hello() == :world
  end
end
