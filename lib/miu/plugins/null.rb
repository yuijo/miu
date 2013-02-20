require 'miu/plugin'

module Miu
  module Plugins
    class Null
      include Miu::Plugin

      class Handler
        def log(tag, time, record)
        end
      end

      def initialize(options)
        require 'msgpack/rpc'
        @server = MessagePack::RPC::Server.new
        @server.listen options[:host], options[:port], Handler.new

        [:TERM, :INT].each do |sig|
          Signal.trap(sig) { @server.stop }
        end

        @server.run
      end

      register :null, :desc => 'Null plugin' do
        desc 'start', 'start null'
        option :bind, :type => :string, :default => '0.0.0.0', :desc => 'bind address', :aliases => '-a'
        option :port, :type => :numeric, :default => 30301, :desc => 'listen port', :aliases => '-p'
        def start
          Null.new options
        end

        desc 'init', 'init null config'
        def init
          append_to_file 'config/miu.god', <<-CONF

God.watch do |w|
  w.dir = Miu.root
  w.log = Miu.root.join('log', 'null.log')
  w.name = 'null'
  w.start = 'bundle exec miu null start'
end
          CONF
          append_to_file 'config/fluent.conf', <<-CONF

# miu null output plugin
<match miu.output.null>
  type msgpack_rpc
  host localhost
  port 30301
</match>
          CONF
        end
      end
    end
  end
end
