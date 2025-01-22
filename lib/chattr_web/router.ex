defmodule ChattrWeb.Router do

  use ChattrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug ChattrWeb.AuthenticateJWT
    plug :accepts, ["json"]
  end

  scope "/api", ChattrWeb do
    pipe_through :api

    post "/signup", UserController, :create
    post "/login", UserController, :login
    post "/login/key", UserController, :login_one_time_key

    get "/auth/refresh", RefreshController, :refresh_access_token
    
    pipe_through :authenticated
    get "/chats/messages", MessageController, :show
    resources "/chats", ChatController, only: [:create]
    get "/chats", ChatController, :show
    post "/chats/add_user", ChatController, :add_user
    delete "/chats/remove_user", ChatController, :leave_chat
    get "/keys", KeyController, :get_key
    post "/keys", KeyController, :put_key
    post "/chats/find_random", ChatController, :set_find_random_chat
  end



  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:chattr, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ChattrWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
