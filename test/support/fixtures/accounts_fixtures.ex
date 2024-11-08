defmodule Chattr.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chattr.Accounts` context.
  """

  @doc """
  Generate a unique users password.
  """
  def unique_users_password, do: "some password#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique users username.
  """
  def unique_users_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        display_name: "some display_name",
        password: unique_users_password(),
        username: unique_users_username()
      })
      |> Chattr.Accounts.create_users()

    users
  end
end
