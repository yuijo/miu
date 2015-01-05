require 'ffi-rzmq'
require 'miu/socket_helpers'

module Miu
  class Hub
    include SocketHelpers

    attr_reader :options

    class << self
      def start(options = {})
        new(options).start
      end
    end

    def initialize(options = {})
      @options = options
    end

    def start
      context = ZMQ::Context.new @options
      frontend_socket = context.socket ZMQ::XSUB
      backend_socket = context.socket ZMQ::XPUB

      establish frontend_socket, @options[:frontend] || {}
      establish backend_socket, @options[:backend] || {}

      ZMQ::Proxy.create frontend_socket, backend_socket
    end
  end
end
