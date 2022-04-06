import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :smart_git, SmartGit.Repo,
  username: "postgres",
  password: "postgres",
  database: "smart_git_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :smart_git, SmartGitWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Z2t33lb1mom6GVmfBcp5VcCpczbpO4UIXqdm6JHet818DNzNiwO0k/0bDAtwVxNy",
  server: false

config :tesla, adapter: Tesla.Mock

# In test we don't send emails.
config :smart_git, SmartGit.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
