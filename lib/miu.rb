require 'miu/version'

module Miu
  class << self
    def root
      @root ||= find_root 'Gemfile'
    end

    def default_port
      22200
    end

    def default_god_config
      'config/miu.god'
    end

    def default_god_port
      default_port + 0
    end

    def default_fluent_config
      'config/fluent.conf'
    end

    def default_fluent_port
      default_port + 1
    end

    def plugins
      @plugins ||= {}
    end

    def register(name, plugin, options = {}, &block)
      name = name.to_s
      usage = options[:usage] || "#{name} [COMMAND]"
      desc = options[:desc] || plugin.to_s

      plugins[name] = plugin
      Miu::CLI.register generate_subcommand(name, plugin, &block), name, usage, desc if block
    end

    def find_root(flag, base = nil)
      require 'pathname'
      path = base || Dir.pwd
      while path && File.directory?(path) && !File.exist?("#{path}/#{flag}")
        parent = File.dirname path
        path = path != parent && parent
      end
      raise 'Could not find root path' unless path
      Pathname.new File.realpath(path)
    end
  end
end
