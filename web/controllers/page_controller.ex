defmodule Til.PageController do
  use Til.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
