defmodule Til.PostView do
  use Til.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Til.PostView, "post.json") }
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Til.PostView, "post.json") }
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      title: post.title,
      body: post.body,
      slug: post.slug
    }
  end
end
