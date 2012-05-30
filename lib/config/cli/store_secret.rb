module Config
  module CLI
    class StoreSecret < Config::CLI::Base

      attr_accessor :secret_name

      attr_accessor :data

      def usage
        "#{name} [<name>]"
      end

      def parse(options, argv, env)
        @data = read_stdin
        @secret_name = argv.shift || "default"
      end

      def execute
        data_dir.secret(secret_name).write(data)
      end

    end
  end
end

