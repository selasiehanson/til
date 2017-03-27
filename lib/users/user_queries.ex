defmodule Til.UserQueries do  
  import Ecto.Query

  alias Til.User
  alias Til.Repo
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def find_by_email_and_password(%{email: email, password: password}) do
    user = Repo.get_by(User, email: email) 
    cond do
      user && checkpw(password,user.password_hash)  ->
        {:ok, user}
      user ->
        {:error, nil}
      true ->
        {:error, nil}
    end
  end
end
