defmodule SmartGit.GithubApi do
  alias SmartGit.GithubApi.GetRepos
  defdelegate get_repos(language, page, per_page), to: GetRepos
end
