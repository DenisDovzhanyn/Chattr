defmodule Chattr.Repo do
  use Ecto.Repo,
    otp_app: :chattr,
    adapter: Ecto.Adapters.Postgres
end
