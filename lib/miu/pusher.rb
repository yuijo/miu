require 'miu'
require 'zmq'
require 'msgpack'

module Miu
  class Pusher
    attr_reader :host, :port
    attr_reader :context, :socket

    def initialize(host = nil, port = nil, options = {})
      @host = host || '127.0.0.1'
      @port = port || Miu.default_pull_port
      @context = options[:context] || ZMQ::Context.new(options[:io_threads] || 1)
      @socket = @context.socket ZMQ::PUSH
      @socket.connect "tcp://#{@host}:#{@port}"
    end

    def close(close_context = true)
      @socket.close
      @context.close if close_context
    end

    def push(tag, time, message)
      time ||= Time.now.to_i
      data = {:tag => tag, :time => time, :message => msg}
      @socket.send "#{tag} #{data.to_msgpack}"
    end
  end
end
