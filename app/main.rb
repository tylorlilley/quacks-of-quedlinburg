require_relative 'api_clients/github_client'

# A stub for apps' entry point class
class Main

  attr_accessor :arg

  def initialize(arg)
    self.arg = arg
  end

  def run
    GithubClient.new.full_name(arg)
  end

end
