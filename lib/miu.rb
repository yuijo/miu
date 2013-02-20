require 'miu/version'

module Miu
  autoload :CLI, 'miu/cli'

  class << self
    def root
      require 'pathname'
      Pathname.new(File.expand_path('../../', __FILE__))
    end

    def plugins
      @plugins ||= {}
    end

    def register(name, type, options = {}, &block)
      name = name.to_s
      usage = options[:usage] || "#{name} [COMMAND]"
      desc = options[:desc] || type.to_s

      plugins[name] = type
      Miu::CLI.register generate_subcommand(name, &block), name, usage, desc if block
    end

    private

    def generate_subcommand(name, &block)
      require 'thor'
      Class.new ::Thor do
        include ::Thor::Actions
        add_runtime_options!

        class << self
          def source_root
            Miu.root.to_s
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
