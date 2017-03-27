defmodule Til.SessionView do  
  use Til.Web, :view

  def render("login.json", %{token: token}) do
    %{data: %{token: token} }
  end

  def render("login_failed.json", %{}) do
    %{errors: ["invalid crendentials"]}
  end
end
