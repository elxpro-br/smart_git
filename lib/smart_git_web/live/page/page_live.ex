defmodule SmartGitWeb.PageLive do
  use SmartGitWeb, :live_view
  alias SmartGitWeb.Shared.RepoDetail
  alias SmartGit.GithubApi
  alias SmartGit.GitRepos


  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _, socket) do
    language = params["language"] || "elixir"
    page = (params["page"] || "1") |> String.to_integer()
    per_page = (params["per_page"] || "5") |> String.to_integer()
    saved_repos = GitRepos.get_saved_repos
    assigns = [language: language, page: page, per_page: per_page, saved_repos: saved_repos]
    socket = socket |> assign(assigns) |> load_repos()
    {:noreply, socket}
  end

  def handle_event("select-language", %{"language" => language}, socket) do
    socket = push_redirect(socket, to: Routes.page_path(socket, :index, language: language))
    {:noreply, socket}
  end

  def handle_event("load_repos", _, socket) do
    socket = socket |> update(:page, &(&1 + 1)) |> load_repos()
    {:noreply, socket}
  end

  defp load_repos(socket) do
    language = socket.assigns.language
    page = socket.assigns.page
    per_page = socket.assigns.per_page
    language |> GithubApi.get_repos(page, per_page) |> get_response(socket)
  end

  defp get_response({:error, message}, socket) do
    socket
    |> put_flash(:error, message)
    |> assign(repos: [])
  end

  defp get_response(repos, socket) do
    assign(socket, repos: repos)
  end
end
