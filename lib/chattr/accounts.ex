defmodule Chattr.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Chattr.Repo

  alias Chattr.Accounts.Users

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%Users{}, ...]

  """
  def list_user do
    Repo.all(Users)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  def get_users!(id), do: Repo.get!(Users, id)

  def get_users_by_username(username), do: Repo.get_by(Users, username: username)

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_users(attrs \\ %{}) do
    %Users{}
    |> Users.changeset(attrs)
    |> Repo.insert()
  end

  def login_users(%{"username" => username, "password" => password}) do
    case get_users_by_username(username) do
      %Users{password: hashed_password} ->
        if Pbkdf2.verify_pass(password, hashed_password) do
         #jwt token given here
          {:ok, "logged in"}
        else
          {:error, "password does not match"}
        end

      _ -> {:error, "user not found"}
    end

  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_users(%Users{} = users, attrs) do
    users
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  def update_users_display_name(%{"user_id" => user_id, "display_name" => display_name}) do
    user = get_users!(user_id)
    user
    |> Users.changeset_for_display_name(%{"display_name" => display_name})
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_users(%Users{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %Users{}}

  """
  def change_users(%Users{} = users, attrs \\ %{}) do
    Users.changeset(users, attrs)
  end
end
