require 'miu/version'
require 'miu/logger'
require 'miu/errors'

module Miu
  autoload :CLI, 'miu/cli'
  autoload :Utility, 'miu/utility'

  autoload :Socket, 'miu/socket'
  autoload :PubSocket, 'miu/socket'
  autoload :SubSocket, 'miu/socket'
  autoload :XPubSocket, 'miu/socket'
  autoload :XSubSocket, 'miu/socket'

  autoload :Server, 'miu/server'
  autoload :Packet, 'miu/packet'
  autoload :Publishable, 'miu/publishable'
  autoload :Subscribable, 'miu/subscribable'
  autoload :Publisher, 'miu/publisher'
  autoload :Subscriber, 'miu/subscriber'
  autoload :Proxy, 'miu/proxy'
  autoload :Forwarder, 'miu/forwarder'

  autoload :Command, 'miu/command'
  autoload :Plugin, 'miu/plugin'
  autoload :Plugins, 'miu/plugins'
  autoload :Type, 'miu/type'
  autoload :Resources, 'miu/resources'
  autoload :Messages, 'miu/messages'

  class << self
    def root
      require 'pathname'
      @root ||= Pathname.new(Dir.pwd)
    end

    def default_port
      Integer(ENV['MIU_DEFAULT_PORT']) rescue  22200
    end

    def default_god_port
      default_port
    end

    def default_pub_port
      default_port + 1
    end

    def default_sub_port
      default_port + 2
    end

    def default_god_config
      'config/miu.god'
    end

    def context
      require 'ffi-rzmq'
      @context ||= ZMQ::Context.new
    end

    def plugins
      @plugins ||= {}
    end

    def load_plugins
      gems.each do |spec|
        @current_spec = spec
        require spec.name
      end
    end

    def register(name, plugin, options = {}, &block)
      plugin.spec = @current_spec
      Miu.plugins[name] = plugin
      usage = options[:usage] || "#{name} [COMMAND]"
      desc = plugin.description
      command = Miu::Command.new name, plugin, &block
      Miu::CLI.register command, name, usage, desc
      command
    end

    def gems
      @gems ||= find_gems
    end

    def find_gems
      Gem::Specification.find_all.select { |spec| spec.name =~ /^miu-/ }
    end
  end
end
