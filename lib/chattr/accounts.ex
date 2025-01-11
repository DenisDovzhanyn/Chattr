defmodule Chattr.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Chattr.UserKey
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
     case %Users{}
      |> Users.changeset(attrs)
      |> Repo.insert() do

      {:ok, user} ->

        keys = Enum.map(1..3, fn _ ->
          single_key = :crypto.strong_rand_bytes(32)
          |> Base.url_encode64()

          %UserKey{}
          |> UserKey.changeset(%{"user_id" => user.id, "key" => single_key, "used" => false})
          |> Repo.insert()

          single_key
        end)

        {:ok, {user, keys}}

      {:error, changeset} -> {:error, changeset}
    end
  end

  def login_users(%{"username" => username, "password" => password}) do
    case get_users_by_username(username) do
      %Users{password: hashed_password, id: id} ->
        if Pbkdf2.verify_pass(password, hashed_password) do

          {:ok, "logged in", id}
        else
          {:error, "Username or Password not found, try again"}
        end

      _ -> {:error, "Username or Password not found, try again"}
    end

  end


  def login_one_time_key(%{"username" => username, "key" => key}) do
    %Users{id: id} = get_users_by_username(username)

    ## I NEED TO MAKE IT SO THAT WHEN A USER USES A ONE TIME KEY, THEY MUST RESET THEIR PASSWORD,
    ## DO I ADD A FIELD IN THE DATABASE SCHEMA WHICH THE CLIENT WILL CHECK UPON LOGIN AND REDIRECT THEM TO RESET?

    case Repo.get_by(UserKey, user_id: id, key: key) do
      %UserKey{user_id: id, key: key, used: used} ->

        if used != true do
          Repo.update_all(
            from(u in UserKey, where: u.user_id == ^id and u.key == ^key),
            set: [used: true])


          {:ok, id}
        else
          {:error, "key already used"}
        end

      _ -> {:error, "Username or Key not found, try again"}
    end
  end


  def set_random_chat(%{"is_finding_random_chat" => is_looking, "user_id" => user_id}) do
    user = get_users!(user_id)
    user
    |> Users.changeset_for_random_chat(%{"find_random_chat" => is_looking})
    |> Repo.update()
  end

  def get_one_user_random_chat() do
    query = from user in Users,
          where: user.find_random_chat == true,
          limit: 1 ## may add a lock here but i need to read a bit more on that

    case Repo.one(query) do
      nil ->
        {:error, :no_available_users}

      user ->
        set_random_chat(%{"is_finding_random_chat" => false, "user_id" => user[:user_id]})
        {:ok, user[:user_id]}
    end
  end

  def update_password(%{"user_id" => user_id, "password" => password}) do
    user = get_users!(user_id)
    user
    |> Users.changeset_for_password(%{"password" => password})
    |> Repo.update()
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
