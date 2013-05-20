require 'miu'
require 'miu/cli_base'
require 'thor'

module Miu
  class CLI < CLIBase
    class << self
      def source_root
        File.expand_path('../templates', __FILE__)
      end

      def destination_root
        Miu.root
      end
    end

    map ['--version', '-v'] => :version
    desc 'version', 'Show version'
    def version
      say "Miu #{Miu::VERSION}"
    end

    desc 'init', 'Generates a miu configuration files'
    def init
      directory 'config'
      empty_directory 'log'
      empty_directory 'tmp/pids'
    end

    desc 'list', 'Lists nodes'
    def list
      table = Miu.nodes.map do |name, node|
        [name, "# #{node.description}"]
      end
      say 'Nodes:'
      print_table table, :indent => 2, :truncate => true
    end

    desc 'server', 'Start miu server'
    option 'pub-host', :type => :string, :default => '127.0.0.1', :desc => 'pub host'
    option 'pub-port', :type => :numeric, :default => Miu.default_pub_port, :desc => 'pub port'
    option 'sub-host', :type => :string, :default => '127.0.0.1', :desc => 'sub host'
    option 'sub-port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'sub port'
    option 'bridge-host', :type => :string, :default => '127.0.0.1', :desc => 'bridge host'
    option 'bridge-port', :type => :numeric, :desc => 'bridge port'
    option 'verbose', :type => :boolean, :default => false, :desc => 'verbose output', :aliases => '-V'
    def server
      server = Miu::Server.new Miu::Utility.optionify_keys(options)
      server.run
    end

    desc 'cat TOPIC ROOM TEXT', 'Okaka kakeyoune'
    option 'host', :type => :string, :default => '127.0.0.1', :desc => 'miu sub host'
    option 'port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'miu sub port'
    option 'network', :type => :string, :default => 'cat', :desc => 'miu network name'
    def cat(topic, room, text)
      require 'miu/messages'
      publisher = Miu::Publisher.new :host => options[:host], :port => options[:port]
      message = Miu::Messages::Text.new do |m|
        m.network.name = options[:network]
        m.content.tap do |c|
          c.room.name = room
          c.text = text
        end
      end

      packet = publisher.write topic, message
      Miu::Logger.info packet.inspect
    rescue => e
      Miu::Logger.exception e
    end

    desc 'supervise', 'Supervise nodes'
    def supervise(*args)
      args.unshift(
        'god',
        "-c #{Miu.root.join(Miu.default_god_config)}",
        "-l #{Miu.root.join('log/god.log')}",
        '--no-syslog',
        '--no-events',
      )
      run args.join(' '), :verbose => false
    end

    desc 'terminate', 'Terminate nodes'
    def terminate(*args)
      args.unshift 'terminate'
      run_god *args
    end

    desc 'start [NODE]', 'Start specified node or all nodes'
    def start(node = :all, *args)
      args.unshift 'start', node
      run_god *args
    end

    desc 'stop [NODE]', 'Stop specified node or all nodes'
    def stop(node = :all, *args)
      args.unshift 'stop', node
      run_god *args
    end

    desc 'restart [NODE]', 'Restart specified node or all nodes'
    def restart(node = :all, *args)
      args.unshift 'restart', node
      run_god *args
    end

    desc 'monitor [NODE]', 'Monitor specified node or all nodes'
    def monitor(node = :all, *args)
      args.unshift 'monitor', node
      run_god *args
    end

    desc 'unmonitor [NODE]', 'Unmonitor specified node or all nodes'
    def unmonitor(node = :all, *args)
      args.unshift 'unmonitor', node
      run_god *args
    end

    desc 'status [NODE]', 'Show status of the specified node or all nodes'
    def status(node = :all, *args)
      args.unshift 'status', node
      run_god *args
    end

    desc 'reload', 'Reload config file'
    def reload(*args)
      args.unshift "load #{Miu.root.join(Miu.default_god_config)}"
      run_god *args
    end

    private

    def run_god(*args)
      args.unshift(
        'god',
        "-p #{Miu.default_god_port}",
      )
      run args.join(' '), :verbose => false
    end
  end
end

# load miu nodes
Miu.load_nodes

