defmodule Til.PostController do
  use Til.Web, :controller
  alias Til.Post

  plug Til.AuthenticatedUser

  def index(conn, _params) do
    render(conn, "index.json", %{ posts: [] })
  end

  def create(conn, %{"post" => params }) do
    user_id = conn.assigns.current_user.id
    changeset = Post.changeset(%Post{user_id: user_id }, params) 
    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:uprocessable_entity)
        |> render(Til.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
