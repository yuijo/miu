require 'msgpack/rpc'

module Miu
  module Store
    class << self
      def strategies
        @@strategies ||= {}
      end

      def register(name, type)
        strategies[name.to_sym] = type
      end

      def start(options = {})
        address = options[:address]
        port = options[:port]
        type = options[:type]

        klass = Miu::Store.strategies[type.to_sym]

        server = MessagePack::RPC::Server.new
        server.listen address, port, klass.new(options)

        [:TERM, :INT].each do |sig|
          Signal.trap(sig) { server.stop }
        end

        server.run
      end
    end
  end
end

require 'miu/store/strategies/null'
