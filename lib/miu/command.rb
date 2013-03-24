require 'miu'
require 'miu/cli_base'

module Miu
  class Command
    def self.new(name, plugin, options = {}, &block)
      Class.new Miu::CLIBase do
        attr_accessor :plugin
        @plugin = plugin

        class << self
          def source_root
            @plugin.spec.full_gem_path rescue nil
          end

          def destination_root
            Miu.root
          end

          def banner(task, namespace = nil, subcommand = nil)
            super task, namespace, subcommand || options.fetch(:subcommand, true)
          end

          def add_miu_pub_options!
            option 'miu-pub-host', :type => :string, :default => '127.0.0.1', :desc => 'miu pub host'
            option 'miu-pub-port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'miu pub port'
          end

          def add_miu_sub_options!
            option 'miu-sub-host', :type => :string, :default => '127.0.0.1', :desc => 'miu sub host'
            option 'miu-sub-port', :type => :numeric, :default => Miu.default_pub_port, :desc => 'miu sub port'
          end
        end

        namespace name
        class_eval &block if block
      end
    end
  end
end
