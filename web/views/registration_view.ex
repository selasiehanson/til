defmodule Til.RegistrationView do
  use Til.Web, :view

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Til.RegistrationView, "user.json", as: :user)}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username
    }
  end

end
