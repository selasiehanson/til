defmodule Til.PostController do
  use Til.Web, :controller
  alias Til.Post

  plug Til.AuthenticatedUser, "create" when action in [:create]
  plug Til.AuthenticatedUser, "update" when action in [:update]

  #plug RsvpWeb.AuthorizedPlug, "create" when action in [:create]

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.json", %{ posts: posts })
  end

  def show(conn, %{"id" => id }) do
    post = Repo.get!(Post, id) |> Repo.preload([:user])
    render(conn,"show.json", post: post)
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

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    if post.user_id != conn.assigns.current_user.id do
      conn 
      |> put_status(:unauthorized)
      |> render(Til.ErrorView, "unauthorized.json")
    else
      changeset = Post.changeset(post, post_params)

      case Repo.update(changeset) do
        {:ok, post} ->
          conn
          |> put_status(:ok)
          |> render("show.json", post: post)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Til.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end
end
