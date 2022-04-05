defmodule SmartGit.GitReposTest do
  use SmartGit.DataCase
  alias SmartGit.GitRepos

  test "create/1" do
    assert create_repo().full_name == "full_name"
  end

  test "all/0" do
    assert [] == GitRepos.all()
  end

  test "get_saved_repos/0" do
    repo = create_repo()
    assert repo.git_id in GitRepos.get_saved_repos()
  end

  test "get_by_git_id/1" do
    repo = create_repo()
    assert repo.full_name == GitRepos.get_by_git_id(repo.git_id).full_name
  end

  defp create_repo do
    payload = %{
      git_id: 123_123,
      avatar_url: "avatar_url",
      full_name: "full_name",
      watchers_count: 123_123,
      forks: 123_123,
      url: "url",
      description: "description",
      name: "name",
      open_issues: 123_213,
      language: "language"
    }

    {:ok, result} = GitRepos.create(payload)
    result
  end
end
