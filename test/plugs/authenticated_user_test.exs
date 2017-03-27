defmodule Til.AuthenticatedUserTest do
  use Til.ConnCase
  alias Til.{AuthenticatedUser, User , Repo}

  @opts AuthenticatedUser.init([])
  @valid_credentials %{email: "bill@mail.com", password: "password"}

  setup do
    conn = build_conn()
    {:ok, conn: conn}
  end

  def create_user(user) do
    signup_changeset = User.signup_changeset(%User{}, user)
    Repo.insert!(signup_changeset)
  end

  test "returns current user for an authenticated user", %{conn: conn} do
    user =  create_user(Map.put(@valid_credentials, :username, "billy jones"))

    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user, :api)
    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
    conn = conn
          |> add_token_to_header(jwt)
          |> AuthenticatedUser.call(@opts)

    assert conn.assigns.current_user
  end

  test "should retirn 401 error when toke is invlaid", %{conn: conn} do
    conn = conn
           |> add_token_to_header("foo")
           |> AuthenticatedUser.call(@opts)

    assert conn.status == 401
    assert conn.halted
  end

  def add_token_to_header(conn, jwt) do 
    conn
    |> put_req_header("authorization", "Bearer #{jwt}")
  end


end
