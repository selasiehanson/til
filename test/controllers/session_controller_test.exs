defmodule Til.SessionControllerTest do
  use Til.ConnCase
  alias Til.User

  @valid_attrs %{email: "bill@mail.com", password: "password"}

  setup do
    signup_changeset = User.signup_changeset(%User{}, Map.put(@valid_attrs, :username, "billy"))
    Repo.insert!(signup_changeset)

    {:ok, conn: put_req_header(build_conn(),"accept", "application/json")}
  end

  test "creates a new sesssion with valid params and return a valid token", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    token =  json_response(conn, 200)["data"]["token"]
    assert token
  end

  test "return error message for invalid crendentials", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: Map.put(@valid_attrs, :email, "haha@haha.com")
    assert json_response(conn, 401)
    errors = json_response(conn, 401)["errors"]
    assert errors
  end
end
