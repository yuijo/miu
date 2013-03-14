require 'miu'
require 'miu/socket'

module Miu
  class Subscriber < Socket
    attr_reader :subscribe

    def initialize(options = {})
      options[:port] ||= Miu.default_pub_port
      super socket_type, options

      self.subscribe = options[:subscribe]
      yield self if block_given?
    end

    def subscribe
      @subscribe
    end

    def subscribe=(value)
      @subscribe = value.to_s
      @socket.setsockopt ZMQ::SUBSCRIBE, @subscribe
    end

    def recv
      parts = []
      @socket.recv_strings parts
      Message.load parts
    end

    def each
      if block_given?
        loop do
          message = recv rescue nil
          yield message if message
        end
      end
    end

    private

    def socket_type
      if ZMQ::LibZMQ.version3?
        ZMQ::XSUB
      else
        ZMQ::SUB
      end
    end
  end
end
