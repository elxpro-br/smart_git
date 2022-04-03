defmodule SmartGitWeb.Shared.RepoDetail do
  use SmartGitWeb, :live_component
  alias SmartGit.GitRepos

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign(message: nil)}
  end

  def handle_event("add-repo", _, socket) do
    repo = socket.assigns.repo
    GitRepos.create(repo)
    message = socket.assigns.message == nil && "Repo added!" || nil
    {:noreply, assign(socket, message: message)}
  end
end
