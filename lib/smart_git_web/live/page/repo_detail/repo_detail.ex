defmodule SmartGitWeb.Page.RepoDetail do
  use SmartGitWeb, :live_component

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign(message: nil)}
  end

  def handle_event("add-repo", _, socket) do
    message = socket.assigns.message == nil && "Repo added!" || nil
    {:noreply, assign(socket, message: message)}
  end
end
