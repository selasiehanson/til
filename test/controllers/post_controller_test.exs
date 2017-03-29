defmodule Til.PostControllerTest do
  use Til.ConnCase
  alias Til.{ Post, User }
  @valid_credentials %{email: "bill@mail.com", password: "password"}
  @valid_attrs %{title: "Sample post", body: "Sample body" }

  describe "For general users" do
    test "returns a list of posts when for an authorized user" do
      conn = build_conn()
      conn = get conn, post_path(conn, :index)
      data = json_response(conn, 200)["data"]
      assert Enum.count(data) == 0
    end

    test "shows a given post" do
      user = create_user(Map.put(@valid_credentials, :username, "billy"))
      changeset = Post.changeset(%Post{user_id: user.id}, @valid_attrs) 
      {:ok, post } = Repo.insert(changeset)
      conn = build_conn() |> put_req_header("accept", "application/json")
      conn = get conn, post_path(conn, :show, post)
      data  = json_response(conn, 200)["data"]
    end
  end

  describe "Signed in users" do

    setup do
      user =  create_user(Map.put(@valid_credentials, :username, "billy jones"))

      {:ok, jwt, _} = Guardian.encode_and_sign(user, :api)
      #{:ok, %{user: user, jwt: jwt, claims: full_claims}}
      conn = build_conn()
             |> put_req_header("authorization", "Bearer #{jwt}")
             |> put_req_header("accept", "application/json")
      {:ok, conn: conn, current_user: user}
    end


    test "create a post for an authorized user", %{conn: conn, current_user: _} do
      conn = post conn, post_path(conn, :create), post: @valid_attrs
      created_post = json_response(conn, 201)["data"]
      assert created_post["id"]
    end

    test "udpdate a post for the user who created the created it", %{conn: conn, current_user: current_user} do
      changeset = Post.changeset(%Post{user_id: current_user.id}, @valid_attrs) 
      post = Repo.insert!(changeset)
      new_title = "Updated title"
      new_body = "Updated body"
      fields_to_update = Map.merge(@valid_attrs, %{
                                     id: post.id,
                                     title: new_title,
                                     body: new_body})

      conn = put conn, post_path(conn, :update, post), post: fields_to_update
      data = json_response(conn, 200)["data"]

      assert data["id"] == post.id
      assert data["title"] == new_title
      assert data["body"] == new_body
    end

     test "udpdate fails for the user who is not the creator of the post", %{conn: conn, current_user: current_user} do
      user_params = %{email: "peter@mail.com", username: "peter", password: "password" }
      new_user = create_user(user_params)

      changeset = Post.changeset(%Post{user_id: new_user.id}, @valid_attrs) 
      post = Repo.insert!(changeset)
      new_title = "Updated title"
      new_body = "Updated body"
      fields_to_update = Map.merge(@valid_attrs, %{
                                     id: post.id,
                                     title: new_title,
                                     body: new_body})

      conn = put conn, post_path(conn, :update, post), post: fields_to_update
      assert json_response(conn, 401)

      #assert data["id"] == post.id
      #assert data["title"] == new_title
      #assert data["body"] == new_body
    end
  end

  def create_user(user) do
    signup_changeset = User.signup_changeset(%User{}, user)
    Repo.insert!(signup_changeset)
  end
end
