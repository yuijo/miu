require 'miu'
require 'ffi-rzmq'

module Miu
  class Socket
    attr_reader :host, :port
    attr_reader :context, :socket

    def initialize(socket_type, options = {})
      @host = options[:host] || '127.0.0.1'
      @port = options[:port]
      @context = Miu.context
      @socket = @context.socket socket_type
    end

    def bind
      rc = @socket.bind "tcp://#{@host}:#{@port}"
      error_check rc
      self
    end

    def connect
      rc = @socket.connect "tcp://#{@host}:#{@port}"
      error_check rc
      self
    end

    def forward(to)
      parts = []
      loop do
        message = ZMQ::Message.new
        @socket.recvmsg message
        parts << message.copy_out_string
        more = @socket.more_parts?
        to.socket.sendmsg message, (more ? ZMQ::SNDMORE : 0)
        return parts unless more
      end
    end

    def close
      @socket.close
    end

    protected

    def error_check(rc, source = nil)
      unless ZMQ::Util.resultcode_ok? rc
        raise ZMQ::ZeroMQError.new source, rc, ZMQ::Util.errno, ZMQ::Util.error_string
      end
      true
    end
  end
end
