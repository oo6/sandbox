defmodule SandboxWeb.Router do
  use SandboxWeb, :router

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

  scope "/", SandboxWeb do
    pipe_through :browser

    get "/", PageController, :index

    scope "/stimulus", as: :stimulus do
      get "/hello", StimulusController, :hello
      get "/clipboard", StimulusController, :clipboard
      get "/slideshow", StimulusController, :slideshow
      get "/content_loader", StimulusController, :content_loader
      get "/date_time", StimulusController, :date_time
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SandboxWeb do
  #   pipe_through :api
  # end
end
