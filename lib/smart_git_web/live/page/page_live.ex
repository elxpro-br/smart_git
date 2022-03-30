defmodule SmartGitWeb.PageLive do
  use SmartGitWeb, :live_view
  alias SmartGitWeb.Page.RepoDetail
  alias SmartGit.GithubApi

  def mount(_params, _session, socket) do
    repos = GithubApi.get_repos()
    {:ok, socket |> assign(repos: repos)}
  end
end
