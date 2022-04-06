defmodule SmartGitWeb.Page.RepoDetailTest do
  use SmartGitWeb.ConnCase
  import Mock
  import Phoenix.LiveViewTest
  alias SmartGit.GithubApi

  test "load repo element", %{conn: conn} do
    items = items()
    [item | _] = items

    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> items end do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
      assert has_element?(view, "##{item.git_id}")
      assert has_element?(view, "[data-role=language][data-id=#{item.git_id}]", item.name)

      assert has_element?(
               view,
               "[data-role=watcher][data-id=#{item.git_id}]",
               "Watchers: #{item.watchers_count}"
             )

      assert has_element?(
               view,
               "[data-role=description][data-id=#{item.git_id}]",
               item.description
             )

      assert has_element?(view, "[data-role=button-action][data-id=#{item.git_id}]")
      refute has_element?(view, "[data-role=show-message][data-id=#{item.git_id}]", "Repo added!")
    end
  end

  test "when click add repo show success message", %{conn: conn} do
    items = items()
    [item | _] = items

    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> items end do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
      refute has_element?(view, "[data-role=show-message][data-id=#{item.git_id}]", "Repo added!")
      view |> element("[data-role=button-action][data-id=#{item.git_id}]") |> render_click()
      assert has_element?(view, "[data-role=show-message][data-id=#{item.git_id}]", "Repo added!")
    end
  end

  test "when repo is added should redirect", %{conn: conn} do
    items = items()
    [item | _] = items

    with_mock GithubApi, get_repos: fn _language, _page, _per_page -> items end do
      {:ok, view, _html} = live(conn, Routes.page_path(conn, :index))
      refute has_element?(view, "[data-role=show-message][data-id=#{item.git_id}]", "Repo added!")
      view |> element("[data-role=button-action][data-id=#{item.git_id}]") |> render_click()
      assert has_element?(view, "[data-role=show-message][data-id=#{item.git_id}]", "Repo added!")

      view
      |> element("[data-role=button-action][data-id=#{item.git_id}]")
      |> render_click()
      |> follow_redirect(conn, "/show_repo/#{item.git_id}")
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
