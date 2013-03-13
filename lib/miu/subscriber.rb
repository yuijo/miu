require 'miu'
require 'zmq'
require 'msgpack'

module Miu
  class Subscriber
    attr_reader :host, :port
    attr_reader :context, :socket
    attr_reader :tag

    def initialize(host = nil, port = nil, options = {})
      @host = host || '127.0.0.1'
      @port = port || Miu.default_pub_port
      @context = options[:context] || ZMQ::Context.new(options[:io_threads] || 1)
      @socket = @context.socket ZMQ::SUB
      @socket.connect "tcp://#{@host}:#{@port}"
      tag = options[:tag]
    end

    def close(close_context = true)
      @socket.close
      @context.close if close_context
    end

    def tag
      @tag
    end

    def tag=(value)
      @tag = value.to_s
      @socket.setsockopt ZMQ::SUBSCRIBE, @tag
    end

    def recv
      data = @socket.recv
      MessagePack.unpack(data)
    end

    def each(&block)
      loop do
        msg = recv rescue nil
        block.call msg if block && msg
      end
    end
  end
end
