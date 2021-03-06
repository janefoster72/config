require 'helper'

describe Config::CLI::InitProject do

  subject { Config::CLI::InitProject }

  specify "#usage" do
    cli.usage.must_equal "test-command"
  end

  describe "#execute" do

    let(:remotes) { MiniTest::Mock.new }

    def git_config(url)
      git_config = MiniTest::Mock.new
      git_config.expect(:url, url)
      git_config
    end

    before do
      cli.remotes_factory = -> { remotes }
    end

    it "executes a blueprint" do
      remotes.expect(:project_git_config, git_config("project.git"))
      remotes.expect(:database_git_config, git_config("project-db.git"))

      cli.execute

      blueprints = cli.find_blueprints(Config::Meta::Project)
      blueprints.size.must_equal 1
      blueprints.first.project_hostname_domain.must_equal "internal.example.com"
      blueprints.first.project_git_config_url.must_equal "project.git"
      blueprints.first.database_git_config_url.must_equal "project-db.git"
    end

    it "doesn't require remotes to be configured" do
      remotes.expect(:project_git_config, git_config(nil))
      remotes.expect(:database_git_config, git_config(nil))

      cli.execute

      blueprints = cli.find_blueprints(Config::Meta::Project)
      blueprints.size.must_equal 1
      blueprints.first.project_hostname_domain.must_equal "internal.example.com"
      blueprints.first.project_git_config_url.must_equal "<git project url>"
      blueprints.first.database_git_config_url.must_equal "<git database url>"
    end
  end
end


