defmodule SmartGitWeb.PageLiveTest do
  use SmartGitWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page elements", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

    assert has_element?(view, "[data-role=btn-language-select][data-id=elixir]", "Elixir")
    assert has_element?(view, "[data-role=btn-language-select][data-id=javascript]", "Javascript")
    assert has_element?(view, "[data-role=btn-language-select][data-id=java]", "Java")
    assert has_element?(view, "[data-role=btn-language-select][data-id=python]", "Python")
    assert has_element?(view, "[data-role=btn-language-select][data-id=go]", "Go")
  end
end
