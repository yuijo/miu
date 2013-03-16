require 'miu'
require 'thor'

module Miu
  class CLI < ::Thor
    include ::Thor::Actions
    add_runtime_options!

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
      copy_file 'Gemfile'
      inside 'config' do
        template 'miu.god'
      end
      empty_directory 'log'
      empty_directory 'tmp/pids'
    end

    desc 'list', 'Lists plugins'
    def list
      require 'miu/plugins'
      table = Miu.plugins.map { |k, v| [k, "# #{v}" ] }
      say 'Plugins:'
      print_table table, :indent => 2, :truncate => true
      say
    end

    desc 'start', 'Start miu'
    option 'pub-host', :type => :string, :default => '127.0.0.1', :desc => 'pub host'
    option 'pub-port', :type => :numeric, :default => Miu.default_pub_port, :desc => 'pub port'
    option 'sub-host', :type => :string, :default => '127.0.0.1', :desc => 'sub host'
    option 'sub-port', :type => :numeric, :default => Miu.default_sub_port, :desc => 'sub port'
    option 'verbose', :type => :boolean, :default => false, :desc => 'verbose output', :aliases => '-V'
    def start
      opts = options.dup
      opts.keys.each { |k| opts[k.gsub('-', '_')] = opts.delete(k) if k.is_a?(::String) }
      server = Miu::Server.new opts
      server.run
    end

    desc 'cat tag [body]', 'Nyan'
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
    def supervise
      require 'god'
      run "bundle exec god -c #{Miu.default_god_config}"
    end

    desc 'god', 'Miu is a god'
    def god(*args)
      require 'god'
      args.unshift "bundle exec god -p #{Miu.default_god_port}"
      run args.join(' ')
    end
  end
end
