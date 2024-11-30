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

  def add_user(chat_id, user_id, socket) do
    :ets.insert(@table_name, {{chat_id, user_id}, socket})
  end

  def get_users(chat_id) do
    :ets.match(@table_name, {{chat_id, :"$2"}, :"$3"})
  end

  def remove_user(chat_id, user_id) do
    :ets.delete(@table_name, {chat_id, user_id})
  end
end
