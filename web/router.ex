defmodule Til.Router do
  use Til.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource

  end

  scope "/", Til do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api", Til do
     pipe_through :api

     resources "/registration", RegistrationController, only: [:create]
     resources "/session", SessionController, only: [:create]
   end

   scope "/api", Til do
      pipe_through [:api, :api_auth]

      resources "/posts", PostController, except: [:new, :edit]
   end
end
