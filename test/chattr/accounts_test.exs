defmodule Chattr.AccountsTest do
  use Chattr.DataCase

  alias Chattr.Accounts

  describe "user" do
    alias Chattr.Accounts.Users

    import Chattr.AccountsFixtures

    @invalid_attrs %{username: nil, password: nil, display_name: nil}

    test "list_user/0 returns all user" do
      users = users_fixture()
      assert Accounts.list_user() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Accounts.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{username: "some username", password: "some password", display_name: "some display_name"}

      assert {:ok, %Users{} = users} = Accounts.create_users(valid_attrs)
      assert users.username == "some username"
      assert users.password == "some password"
      assert users.display_name == "some display_name"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{username: "some updated username", password: "some updated password", display_name: "some updated display_name"}

      assert {:ok, %Users{} = users} = Accounts.update_users(users, update_attrs)
      assert users.username == "some updated username"
      assert users.password == "some updated password"
      assert users.display_name == "some updated display_name"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_users(users, @invalid_attrs)
      assert users == Accounts.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Accounts.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Accounts.change_users(users)
    end
  end
end
