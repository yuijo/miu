require 'miu/version'

module Miu
  autoload :CLI, 'miu/cli'
  autoload :Command, 'miu/command'
  autoload :Server, 'miu/server'
  autoload :Pusher, 'miu/pusher'
  autoload :Subscriber, 'miu/subscriber'

  class << self
    def root
      @root ||= find_root 'Gemfile'
    end

    def default_port
      22200
    end

    def default_god_port
      default_port
    end

    def default_pull_port
      default_port + 1
    end

    def default_pub_port
      default_port + 2
    end

    def default_god_config
      'config/miu.god'
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

    def plugins
      @plugins ||= {}
    end

    def register(name, plugin, options = {}, &block)
      Miu.plugins[name] = plugin
      if block
        usage = options[:usage] || "#{name} [COMMAND]"
        desc = options[:desc] || plugin.to_s
        command = Miu::Command.new name, plugin, &block
        Miu::CLI.register command, name, usage, desc
      end
    end
  end
end
