defmodule ChattrWeb.ConnectedUsers do
  use GenServer

  @table_name :connected_users

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl
  def init(_) do
    :ets.new(@table_name, [:named_table, :set, :public])
    {:ok, %{}}
  end

  def add_user(user_id, socket) do
    Process.monitor(socket.transport_pid)
    :ets.insert(@table_name, {user_id, socket})
  end

  def get_users(user_id) do
    :ets.match(@table_name, {user_id, :"$2"})
  end

  def remove_user(user_id) do
    :ets.delete(@table_name, user_id)
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    [{user_id}] = :ets.match_object(@table_name, {:"$1", %{transport_pid: pid}})
    remove_user(user_id)
    {:noreply, state}
  end
end
