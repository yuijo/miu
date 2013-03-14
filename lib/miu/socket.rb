require 'miu'
require 'ffi-rzmq'

module Miu
  class Socket
    attr_reader :host, :port
    attr_reader :context, :socket

    def initialize(socket_type, options = {})
      @host = options[:host] || '127.0.0.1'
      @port = options[:port]

      if options[:context]
        @context = options[:context]
        @terminate_context = false
      else
        @context = ZMQ::Context.new(options[:io_threads] || 1)
        @terminate_context = true
      end

      @socket = @context.socket socket_type
    end

    def bind
      @socket.bind "tcp://#{@host}:#{@port}"
    end

    def connect
      @socket.connect "tcp://#{@host}:#{@port}"
    end

    def forward(forwarder)
      loop do
        message = ZMQ::Message.new
        @socket.recvmsg message
        more = @socket.more_parts?
        forwarder.socket.sendmsg message, (more ? ZMQ::SNDMORE : 0)
        break unless more
      end
    end

    def close
      @socket.close
      @context.terminate if @terminate_context
    end
  end
end
