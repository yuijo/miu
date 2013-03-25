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

    desc 'list', 'Lists plugins'
    def list
      table = Miu.plugins.map do |name, plugin|
        [name, "# #{plugin.description}"]
      end
      say 'Plugins:'
      print_table table, :indent => 2, :truncate => true
    end

    desc 'start', 'Start miu server'
    option 'pub-host', :type => :string, :default => '127.0.0.1', :desc => 'pub host'
    option 'pub-port', :type => :numeric, :default => Miu.default_pub_port, :desc => 'pub port'
    option 'sub-host', :type => :string, :default => '127.0.0.1', :desc => 'sub host'
    option 'sub-port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'sub port'
    option 'verbose', :type => :boolean, :default => false, :desc => 'verbose output', :aliases => '-V'
    def start
      server = Miu::Server.new Miu::Utility.optionify_keys(options)
      server.run
    end

    desc 'cat TAG [BODY]', 'Okaka kakeyoune'
    option 'host', :type => :string, :default => '127.0.0.1', :desc => 'miu sub host'
    option 'port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'miu sub port'
    def cat(tag, body = nil)
      require 'json'
      publisher = Miu::Publisher.new :host => options[:host], :port => options[:port]
      publisher.connect
      body = JSON.load(body) rescue body
      publisher.send tag, body
    end

    desc 'supervise', 'Supervise miu and plugins'
    def supervise(*args)
      args.unshift "-c #{Miu.default_god_config}"
      run_god *args
    end

    desc 'terminate', 'Terminate miu and plugins'
    def terminate(*args)
      args.unshift "-p #{Miu.default_god_port} terminate"
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

# load miu plugins
Miu.load_plugins

