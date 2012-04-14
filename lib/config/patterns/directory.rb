module Config
  module Patterns
    class Directory < Config::Pattern

      desc "The full path of the directory"
      key :path

      desc "The user that owns the directory"
      attr :owner, nil

      desc "The group that owns the directory"
      attr :group, nil

      desc "The octal mode of the directory, such as 0755"
      attr :mode, nil

      desc "Set the mtime of the directory to now"
      attr :touch, false

      def describe
        "Directory #{pn}"
      end

      def create
        unless pn.exist?
          pn.mkdir
          changed! "created"
        end

        #stat = Config::Core::Stat.new(self, path)
        #stat.owner = owner if owner
        #stat.group = group if group
        #stat.mode = mode if mode
        #stat.touch if touch
      end

      def destroy
        if pn.exist?
          pn.rmtree
          changed! "deleted"
        end
      end

    protected

      def pn
        @pn ||= Pathname.new(path).cleanpath
      end

    end
  end
end
