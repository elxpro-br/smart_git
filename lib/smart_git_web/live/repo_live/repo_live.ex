defmodule SmartGitWeb.RepoLive do
  use SmartGitWeb, :live_view
  alias SmartGit.GitRepos
  alias SmartGitWeb.Shared.RepoDetail

  def mount(_, _, socket) do
    repos = GitRepos.all()
    socket = assign(socket, repos: repos)
    {:ok, socket}
  end
end
