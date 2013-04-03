require 'miu/socket'
require 'miu/proxy'
require 'ffi-rzmq'

module Miu
  class Forwarder
    def initialize(options = {})
      @pub = pub_socket_class.new
      @pub.bind options[:pub_host], options[:pub_port]

      @sub = sub_socket_class.new
      @sub.bind options[:sub_host], options[:sub_port]
      @sub.subscribe ''

      if options[:bridge_port]
        @bridge = sub_socket_class.new
        @bridge.connect options[:bridge_host], options[:bridge_port]
        @bridge.subscribe ''
      end
    end

    def close
      @bridge.close if @bridge
      @sub.close
      @pub.close
    end

    def run
      frontends = [@sub, @bridge].compact
      backends = [@pub]

      proxy = Proxy.new frontends, backends
      proxy.run
    end

    private

    def pub_socket_class
      if ::ZMQ::LibZMQ.version3?
        XPubSocket
      else
        PubSocket
      end
    end

    def sub_socket_class
      if ::ZMQ::LibZMQ.version3?
        XSubSocket
      else
        SubSocket
      end
    end
  end
end
