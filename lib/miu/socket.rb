require 'miu'
require 'ffi-rzmq'

module Miu
  class Socket
    attr_reader :host, :port
    attr_reader :context, :socket

    def initialize(options = {})
      @host = options[:host] || '127.0.0.1'
      @port = options[:port]
      @context = Miu.context
      @socket = @context.socket options[:socket_type]
    end

    def bind
      error_wrapper do
        @socket.bind "tcp://#{@host}:#{@port}"
      end
      self
    end

    def connect
      error_wrapper do
        socket.connect "tcp://#{@host}:#{@port}"
      end
      self
    end

    def close
      @socket.close
    end

    protected

    def error_wrapper(source = nil, &block)
      rc = block.call
      unless ZMQ::Util.resultcode_ok? rc
        raise ZMQ::ZeroMQError.new source, rc, ZMQ::Util.errno, ZMQ::Util.error_string
      end
      true
    end
  end
end
