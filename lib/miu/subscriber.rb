require 'miu/socket'
require 'miu/packet'
require 'miu/messages'
require 'ffi-rzmq'

module Miu
  class Subscriber < Socket
    attr_reader :subscribe

    def initialize(options = {})
      options[:socket_type] ||= ZMQ::SUB
      options[:port] ||= Miu.default_pub_port
      super options

      yield self if block_given?
    end

    def subscribe(value = nil)
      value = value.to_s
      unsubscribe if subscribe? && @subscribe != value
      @subscribe = value
      @socket.setsockopt ZMQ::SUBSCRIBE, @subscribe
      @subscribe
    end

    def unsubscribe
      if @subscribe
        @socket.setsockopt ZMQ::UNSUBSCRIBE, @subscribe
        @subscribe = nil
      end
      nil
    end

    def subscribe?
      !!@subscribe
    end

    def recv
      subscribe unless subscribe?
      parts = []
      @socket.recv_strings parts
      Packet.load parts
    end

    def each
      if block_given?
        loop do
          packet = recv rescue nil
          yield packet if packet
        end
      end
    end
  end
end
