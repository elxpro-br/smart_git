defmodule SmartGitWeb.Shared.RepoDetail do
  use SmartGitWeb, :live_component
  alias SmartGit.GitRepos

  def update(%{saved_repos: nil} = assigns, socket) do
    socket = socket |> assign_default(assigns) |> assign(icon: "go.html")
    {:ok, socket}
  end

  def update(%{id: id, saved_repos: saved_repos} = assigns, socket) do
    socket = socket |> assign_default(assigns) |> choose_icon(id, saved_repos)
    {:ok, socket}
  end

  def handle_event("add-repo", _, socket) do
    icon = socket.assigns.icon
    repo = socket.assigns.repo

    if icon == "add.html" do
      repo = socket.assigns.repo
      GitRepos.create(repo)
      message = (socket.assigns.message == nil && "Repo added!") || nil
      {:noreply, assign(socket, message: message, icon: "go.html")}
    else
      socket = push_redirect(socket, to: Routes.show_repo_path(socket, :index, repo.git_id))
      {:noreply, socket}
    end
  end

  defp assign_default(socket, %{repo: repo, id: id}) do
    assign(socket, repo: repo, id: id, message: nil)
  end

  defp choose_icon(socket, id, saved_repos) do
    if id in saved_repos do
      assign(socket, icon: "go.html")
    else
      assign(socket, icon: "add.html")
    end
  end
end
