defmodule Til.RegistrationControllerTest do  
  use Til.ConnCase

  @valid_attrs %{email: "bill@mail.com", username: "William Ansah", password: "password"}
  @invalid_attrs %{}
  setup do
    {:ok, conn: put_req_header(build_conn(), "accept", "application/json")}
  end

  test "creates a new user with the specified details", %{conn: conn} do
   conn = post conn, registration_path(conn, :create), user: @valid_attrs 
   assert json_response(conn, 201)
  end

  test "does note create user with invalid params", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does note create user with invalid email format", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: Map.put(@valid_attrs, :email, "abcd")
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does note create user with invalid password length", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: Map.put(@valid_attrs, :password, "1")
    assert json_response(conn, 422)["errors"] != %{}
  end
  
end
