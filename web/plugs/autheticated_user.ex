defmodule Til.AuthenticatedUser do
  import Plug.Conn
  alias Til.{User, Repo}

  def init(options), do: options

  def call(conn, _opts) do
    case find_user(conn) do
      {:ok, user}  -> assign(conn, :current_user, user )
       _ -> auth_error!(conn)
    end
  end

  defp auth_error!(conn) do
    conn 
    |> put_status(:unauthorized)
    |> halt()
  end

  defp find_user(conn) do
    with auth_header = get_req_header(conn, "authorization"),
      {:ok, token } <- parse_token(auth_header),
      {:ok, user_id } <- find_user_by_token(token),
    do: find_user_by_id(user_id)
  end

  defp parse_token(["Bearer "<> token]) do
    {:ok, String.replace(token, "\"","")}
  end

  defp parse_token(_), do: :error

  defp find_user_by_token(token) do
    case Guardian.decode_and_verify(token)  do
      {:ok, %{"sub" => sub }} -> 
        "User:" <> user_id = sub 
        {:ok, String.to_integer(user_id) }
      _ ->
        {:error }
    end
  end

  defp find_user_by_id(user_id) do
    case Repo.get(User, user_id) do
      nil -> { :error }
      user -> {:ok , user }
    end
  end


end
