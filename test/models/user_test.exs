defmodule Til.UserTest do
  use Til.ModelCase

  alias Til.User

  @valid_attrs %{email: "bill@mail.com", password: "some content", username: "william ansah"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "signup changeset with valid attributes" do
    signup_changeset = User.signup_changeset(%User{}, @valid_attrs)
    assert signup_changeset.changes.password_hash
    assert signup_changeset.valid?
  end

  test "signup changeset with invalid attributes" do
    signup_changeset = User.signup_changeset(%User{}, @invalid_attrs)
    refute signup_changeset.valid?
  end

  test "signup changeset with password invalid password length" do
    signup_changeset = User.signup_changeset(%User{}, Map.put(@valid_attrs, :password, "1234"))
    refute signup_changeset.valid?
  end

  test "signup changeset with email invalid" do
    signup_changeset = User.signup_changeset(%User{}, Map.put(@valid_attrs, :email, "abc"))
    refute signup_changeset.valid?
  end
end
