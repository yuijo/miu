require 'miu'

module Miu
  class Command
    def self.new(name, node, options = {}, &block)
      require 'miu/cli_base'

      Class.new Miu::CLIBase do
        attr_accessor :node
        @node = node

        class << self
          def source_root
            @node.spec.full_gem_path rescue nil
          end

          def destination_root
            Miu.root
          end

          def banner(task, namespace = nil, subcommand = nil)
            super task, namespace, subcommand || options.fetch(:subcommand, true)
          end

          def add_miu_pub_options(tag)
            option 'pub-host', :type => :string, :default => '127.0.0.1', :desc => 'miu pub host'
            option 'pub-port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'miu pub port'
            option 'pub-tag', :type => :string, :default => tag, :desc => 'miu pub tag'
          end

          def add_miu_sub_options(tag)
            option 'sub-host', :type => :string, :default => '127.0.0.1', :desc => 'miu sub host'
            option 'sub-port', :type => :numeric, :default => Miu.default_pub_port, :desc => 'miu sub port'
            option 'sub-tag', :type => :string, :default => tag, :desc => 'miu sub tag'
          end
        end

        unless respond_to? :no_commands
          class << self
            alias_method :no_commands, :no_tasks
          end
        end

        no_commands do
         def invoke_command(command, *args)
           Miu.logger.level = ::Logger::DEBUG if options['verbose'] && Miu.logger
           super
         end

         def config(data = nil, &block)
           data = block.call if !data && block
           append_to_file Miu.root.join(Miu.default_god_config), "\n#{data}"
         end
        end

        class_option :force, :type => :boolean, :group => :runtime, :desc => 'Overwrite files that already exist'
        class_option :pretend, :type => :boolean, :group => :runtime, :desc => 'Run but do not make any changes'
        class_option :verbose, :type => :boolean, :group => :runtime, :desc => 'Verbose status output'
        class_option :quiet, :type => :boolean, :group => :runtime, :desc => 'Suppress status output'
        class_option :skip, :type => :boolean, :group => :runtime, :desc => 'Skip files that already exist'

        namespace name
        class_eval &block if block
      end
    end
  end
end
