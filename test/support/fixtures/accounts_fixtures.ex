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

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Chattr.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
