defmodule SmartGitWeb.PageLiveTest do
  use SmartGitWeb.ConnCase
  import Mock
  import Phoenix.LiveViewTest
  alias SmartGit.GithubApi
  alias SmartGit.GitRepos

  test "load page elements", %{conn: conn} do
    items = items()

    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> items end do
      items |> hd |> GitRepos.create()
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

      assert has_element?(view, "[data-role=btn-language-select][data-id=elixir]", "Elixir")

      assert has_element?(
               view,
               "[data-role=btn-language-select][data-id=javascript]",
               "Javascript"
             )

      assert has_element?(view, "[data-role=btn-language-select][data-id=java]", "Java")
      assert has_element?(view, "[data-role=btn-language-select][data-id=python]", "Python")
      assert has_element?(view, "[data-role=btn-language-select][data-id=go]", "Go")
      assert has_element?(view, "##{items |> hd |> then(& &1.git_id)}")
    end
  end

  test "error message", %{conn: conn} do
    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> {:error, "test message"} end do
      {:ok, _view, html} = live(conn, Routes.page_path(conn, :index))
      assert html =~ "test message"
    end
  end

  test "select pages", %{conn: conn} do
    items = items()

    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> items end do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

      view
      |> element("[data-role=btn-language-select][data-id=go]", "Go")
      |> render_click()
      |> follow_redirect(conn, "/?language=go")
    end
  end

  test "test load-repos with hooks", %{conn: conn} do
    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> items() end do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))

      assert view
             |> element("#allrepos")
             |> render()
             |> Floki.parse_fragment!()
             |> Floki.find(".p-10")
             |> Enum.count() == 10

      view
      |> element("#load-repos")
      |> render_hook("load_repos", %{})

      assert view
             |> element("#allrepos")
             |> render()
             |> Floki.parse_fragment!()
             |> Floki.find(".p-10")
             |> Enum.count() == 15
    end
  end

  defp items do
    Enum.map(
      1..5,
      &%{
        git_id: :rand.uniform(10_000),
        avatar_url: "avatar_url-#{&1}",
        full_name: "full_namel-#{&1}",
        watchers_count: 123_123,
        forks: 1232,
        url: "urll-#{&1}",
        description: "descriptionl-#{&1}",
        name: "namel-#{&1}",
        open_issues: 23_232,
        language: "languagel-#{&1}"
      }
    )
  end
end
