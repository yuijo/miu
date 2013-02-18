require 'miu/store/base'

module Miu
  module Store
    class << self
      def start(options = {})
        address = options[:address]
        port = options[:port]
        type = options[:type]

        require "miu/store/#{type}"
        store_class = const_get(camelize(type))

        server = MessagePack::RPC::Server.new
        server.listen address, port, store_class.new(options)

        [:TERM, :INT].each do |sig|
          Signal.trap(sig) { server.stop }
        end

        server.run
      end

      private

      def camelize(term)
        term.to_s.sub(/^[a-z\d]*/) { $&.capitalize }.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      end
    end
  end
end
