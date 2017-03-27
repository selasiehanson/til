defmodule Til.PostTest do
  use Til.ModelCase

  alias Til.Post

  @valid_attrs %{body: "some content", likes: 42, published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, slug: "some content", title: "some content", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
