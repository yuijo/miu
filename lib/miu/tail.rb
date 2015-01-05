require 'ffi-rzmq'
require 'msgpack'
require 'miu/socket_helpers'

module Miu
  class Tail
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
      socket = context.socket ZMQ::SUB

      socket.setsockopt ZMQ::SUBSCRIBE, @options[:topic] || ''
      establish socket, @options

      loop do
        msgs = []
        socket.recv_strings msgs

        topic = msgs[0]
        msg = MessagePack.unpack msgs[1]

        puts "<#{topic}> #{msg}"
      end
    end
  end
end
