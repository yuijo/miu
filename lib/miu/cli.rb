require 'miu'
require 'miu/cli_base'
require 'thor'

module Miu
  class CLI < CLIBase
    class << self
      def source_root
        File.expand_path('../../templates', __FILE__)
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
      inside 'config' do
        template 'miu.god'
      end
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

    desc 'start', 'Start miu server'
    option 'pub-host', :type => :string, :default => '127.0.0.1', :desc => 'pub host'
    option 'pub-port', :type => :numeric, :default => Miu.default_pub_port, :desc => 'pub port'
    option 'sub-host', :type => :string, :default => '127.0.0.1', :desc => 'sub host'
    option 'sub-port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'sub port'
    option 'bridge-host', :type => :string, :default => '127.0.0.1', :desc => 'bridge host'
    option 'bridge-port', :type => :numeric, :desc => 'bridge port'
    option 'verbose', :type => :boolean, :default => false, :desc => 'verbose output', :aliases => '-V'
    def start
      server = Miu::Server.new Miu::Utility.optionify_keys(options)
      server.run
    end

    desc 'cat TAG ROOM TEXT', 'Okaka kakeyoune'
    option 'host', :type => :string, :default => '127.0.0.1', :desc => 'miu sub host'
    option 'port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'miu sub port'
    option 'network', :type => :string, :default => 'cat', :desc => 'miu network name'
    def cat(tag, room, text)
      require 'miu/messages'
      publisher = Miu::Publisher.new :host => options[:host], :port => options[:port]
      message = Miu::Messages::Text.new do |m|
        m.network.name = options[:network]
        m.content.tap do |c|
          c.room.name = room
          c.text = text
        end
      end

      packet = publisher.write tag, message
      Miu::Logger.info packet.inspect
    rescue => e
      Miu::Logger.exception e
    end

    desc 'supervise', 'Supervise miu and nodes'
    def supervise(*args)
      args.unshift "-c #{Miu.default_god_config}"
      run_god *args
    end

    desc 'terminate', 'Terminate miu and nodes'
    def terminate(*args)
      args.unshift "-p #{Miu.default_god_port} terminate"
      run_god *args
    end

    desc 'reload', 'Reload god config'
    def reload(*args)
      args.unshift "-p #{Miu.default_god_port} load #{Miu.default_god_config}"
      run_god *args
    end

    desc 'god [ARGS]', 'Miu is a god'
    def god(*args)
      args.unshift "-p #{Miu.default_god_port}"
      run_god *args
    end

    private

    def run_god(*args)
      require 'god'
      args.unshift 'god'
      run args.join(' ')
    end
  end
end

# load miu nodes
Miu.load_nodes

