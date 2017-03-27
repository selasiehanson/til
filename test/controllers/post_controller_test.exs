defmodule Til.PostControllerTest do
  use Til.ConnCase
  alias Til.User
  @valid_credentials %{email: "bill@mail.com", password: "password"}
  @valid_attrs %{title: "Sample post", body: "Sample body" }

  setup do
    user =  create_user(Map.put(@valid_credentials, :username, "billy jones"))

    {:ok, jwt, _} = Guardian.encode_and_sign(user, :api)
    #{:ok, %{user: user, jwt: jwt, claims: full_claims}}
    conn = build_conn()
           |> put_req_header("authorization", "Bearer #{jwt}")
           |> put_req_header("accept", "application/json")
    {:ok, conn: conn, current_user: user}
  end

  test "returns a list of posts when for an authorized user", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    data = json_response(conn, 200)["data"]
    assert Enum.count(data) == 0
  end

  test "create a post for an authorized user", %{conn: conn, current_user: _} do
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    created_post = json_response(conn, 201)["data"]
    assert created_post["id"]
  end

  def create_user(user) do
    signup_changeset = User.signup_changeset(%User{}, user)
    Repo.insert!(signup_changeset)
  end
end
