defmodule SmartGit.GithubApi do
  alias SmartGit.GithubApi.GetRepos
  defdelegate get_repos, to: GetRepos
end
