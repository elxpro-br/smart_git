defmodule SmartGitWeb.Page.RepoDetailTest do
  use SmartGitWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load repo element", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
    assert has_element?(view, "#repo-1")
    assert has_element?(view, "[data-role=language][data-id=repo-1]", "Elixir language")
    assert has_element?(view, "[data-role=watcher][data-id=repo-1]", "500")
    assert has_element?(view, "[data-role=description][data-id=repo-1]", "Lorem ipsum")
    assert has_element?(view, "[data-role=button-action][data-id=repo-1]")
    refute has_element?(view, "[data-role=show-message][data-id=repo-1]", "Repo added!")
  end

  test "when click add repo show success message", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
    refute has_element?(view, "[data-role=show-message][data-id=repo-1]", "Repo added!")
    view |> element("[data-role=button-action][data-id=repo-1]") |> render_click()
    assert has_element?(view, "[data-role=show-message][data-id=repo-1]", "Repo added!")
  end
end
