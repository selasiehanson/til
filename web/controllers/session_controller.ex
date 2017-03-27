defmodule Til.SessionController do
  
  use Til.Web, :controller
  alias Til.UserQueries

  def create(conn, %{ "user" => %{"email" => email, "password" => password} }) do 
    # find and confirm user
    case UserQueries.find_by_email_and_password(%{email: email, password: password}) do
      {:ok, user} ->
        {:ok, token, _} = Guardian.encode_and_sign(user, :api)
        render(conn, "login.json", %{token: token})
      {:error, _ } ->
        conn
        |> put_status(:unauthorized)
        |> render("login_failed.json", %{})
        |> halt
    end
  end
end
