require 'miu'

module Miu
  class Command
    def self.new(name, plugin, options = {}, &block)
      require 'thor'
      Class.new ::Thor do
        include ::Thor::Actions
        add_runtime_options!

        class << self
          def source_root
            Miu.find_root('Gemfile', plugin.called_from)
          end

          def destination_root
            Miu.root
          end

          def banner(task, namespace = nil, subcommand = nil)
            super task, namespace, subcommand || options.fetch(:subcommand, true)
          end
        end

        namespace name
        class_eval &block if block
      end
    end
  end
end
