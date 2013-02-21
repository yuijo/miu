require 'miu'

module Miu
  module Plugin
    def self.included(base)
      base.extend ClassMethods
      base.called_from = begin
        call_stack = caller.map { |p| p.sub(/:\d+.*/, '') }
        File.dirname(call_stack.detect { |p| p !~ %r(miu[\w.-]*/lib/miu/plugins) })
      end
    end

    module ClassMethods
      attr_accessor :called_from

      def register(*args, &block)
        require 'miu/cli'
        options = args.last.is_a?(::Hash) ? args.pop : {}
        name = args.shift
        plugin = args.shift || self
        usage = options[:usage] || "#{name} [COMMAND]"
        desc = options[:desc] || plugin.to_s

        Miu.plugins[name] = plugin
        Miu::CLI.register generate_subcommand(name, plugin, &block), name, usage, desc if block
      end

      private

      def generate_subcommand(name, plugin, &block)
        require 'thor'
        require 'thor/group'
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

            def banner(task, namespace = nil, subcommand = true)
              super
            end
          end

          namespace name
          class_eval &block if block
        end
      end
    end
  end
end
