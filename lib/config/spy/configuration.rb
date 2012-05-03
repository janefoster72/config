module Config
  module Spy
    # Spy::Configuration is an an alternative implementation of
    # Config::Configuration that returns fake values for any group or
    # key that's accessed.
    #
    # Spies can be used to inspect the execution of your Blueprint or
    # Pattern.
    class Configuration

      def initialize
        @groups = {}
      end

      # Internal: Retrieve the groups that have been accessed. Use this
      # to find out what happened.
      #
      # Returns an Array of Config::Spy::Configuration::Group.
      def get_accessed_groups
        @groups.values
      end

      def to_s
        "<Spy Configuration>"
      end

      def [](group_name)
        unless group_name.is_a?(Symbol)
          raise ArgumentError, "Group Name must be a Symbol, got #{group_name.inspect}" 
        end
        @groups[group_name] ||= Group.new(group_name)
      end

      # Enables dot syntax for groups.
      def method_missing(message, *args, &block)
        raise ArgumentError, "arguments are not allowed: #{message}(#{args.inspect})" if args.any?
        self[message]
      end

      class Group
        include Config::Core::Loggable

        def initialize(name)
          @name = name
          @keys = Set.new
        end

        # Internal: Retrieve the keys that have been accessed. Use this
        # to find out what happened.
        #
        # Returns an Array of Symbol.
        def get_accessed_keys
          @keys.to_a
        end

        def [](key)
          unless key.is_a?(Symbol)
            raise ArgumentError, "Key must be a Symbol, got #{key.inspect}" 
          end
          @keys << key
          value = "fake:#{@name}.#{key}"
          log << "Read #{@name}.#{key} => #{value.inspect}"
          value
        end

        # Enables dot syntax for keys.
        def method_missing(message, *args, &block)
          raise ArgumentError, "arguments are not allowed: #{message}(#{args.inspect})" if args.any?
          self[message]
        end
      end
    end
  end
end
