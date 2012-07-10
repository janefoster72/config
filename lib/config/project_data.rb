module Config
  # This class manages everything that's not checked into the project
  # repository.
  class ProjectData

    def initialize(path)
      @path = Pathname.new(path)
    end

    attr_reader :path

    # Manage a secret.
    #
    # name - Symbol name of the secret.
    #
    # Returns a Config::Data::File.
    def secret(name)
      Config::Data::File.new(@path + "secret-#{name}")
    end

    # Manage an SSH private key.
    #
    # name - Symbol name of the key.
    #
    # Returns a Config::Data::File.
    def ssh_key(name)
      Config::Data::File.new(@path + "ssh-key-#{name}")
    end

    # Manage the signature for an SSH known host.
    #
    # host - String name of the host.
    #
    # Returns a Config::Data::File.
    def ssh_host_signature(host)
      Config::Data::File.new(@path + "ssh-host-#{host}")
    end

    def domain(name)
      Config::Data::File.new(@path + "domain-#{name}")
    end

    # Get the stored accumulation.
    #
    # Returns a Config::Core::Accumulation or nil.
    def accumulation
      data = accumulation_file.read
      Config::Core::Accumulation.from_string(data) if data
    end

    # Store the accumulation.
    #
    # accumulation - Config::Core::Accumulation.
    #
    # Returns nothing.
    def accumulation=(accumulation)
      accumulation_file.write(accumulation.serialize)
    end

    # Get the configured remotes.
    #
    # Returns a Config::Core::Remotes or nil.
    def remotes
      data = remotes_file.read
      Config::Core::Remotes.load_yaml(data) if data
    end

    # Store the remotes configuration.
    #
    # remotes - Config::Core::Remotes to store.
    #
    # Returns nothing.
    def remotes=(remotes)
      remotes_file.write(remotes.dump_yaml)
    end

    # Get the project database.
    #
    # Returns a Config::Data::GitDatabase.
    def database
      Config::Data::GitDatabase.new(database_git_repo.path, database_git_repo)
    end

  protected

    def accumulation_file
      Config::Data::File.new(@path + "accumulation.marshall")
    end

    def remotes_file
      Config::Data::File.new(@path + "remotes.yml")
    end

    def database_git_repo
      Config::Core::GitRepo.new(@path + "project-data")
    end
  end
end
