defmodule Til.RegistrationController do
  use Til.Web, :controller
  alias Til.User

  def create(conn, %{"user" => params }) do 
    changeset = User.signup_changeset(%User{}, params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Til.ChangesetView,"error.json", changeset: changeset)
    end
  end
end
