defmodule SandboxWeb.Router do
  use SandboxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SandboxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward "/graphql", Absinthe.Plug, schema: SandboxWeb.Schema

  scope "/", SandboxWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/html/*path", HTMLController, :show

    scope "/stimulus", as: :stimulus do
      get "/hello", StimulusController, :hello
      get "/clipboard", StimulusController, :clipboard
      get "/slideshow", StimulusController, :slideshow
      get "/content_loader_vs_live_view", StimulusController, :content_loader_vs_live_view
      live "/live_view", StimulusLive
      get "/date_time", StimulusController, :date_time
    end

    scope "/mealthy", as: :mealthy do
      get "/recipes", MealthyController, :list_recipes
      get "/recipes/:id/edit", MealthyController, :edit_recipe
    end

    live "/gomoku", GomokuLive
    live "/gomoku/:id", GomokuLive

    resources "/images", ImageController
  end

  # Other scopes may use custom stacks.
  scope "/api", SandboxWeb do
    pipe_through :api

    resources "/books", BookController, only: [:index, :show] do
      post "/order", BookController, :order
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: SandboxWeb.Telemetry,
        ecto_repos: Application.fetch_env!(:sandbox, :ecto_repos)
    end
  end
end
