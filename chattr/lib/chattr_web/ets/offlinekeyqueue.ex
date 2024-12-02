defmodule ChattrWeb.OfflineKeyQueue do
  use GenServer

  @table_name :offline_keys

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl
  def init(_) do
    :ets.new(@table_name, [:named_table, :set, :public])
    {:ok, %{}}
  end

  def add_key(user_id, key) do
    :ets.update_counter(@table_name, user_id, {2, 1}, {user_id, []})
    :ets.update_element(@table_name, user_id, {2, fn keys -> [key | keys] end})
  end

  def get_keys(user_id) do
    :ets.lookup(@table_name, user_id)
  end

  def remove_keys(user_id) do
    :ets.delete(@table_name, user_id)
  end
end
