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
      packet = Packet.load parts

      begin
        hash = Miu::Utility.symbolize_keys(packet.data, true) rescue {}
        message_class = Miu::Messages.guess(hash[:type])
        packet.data = message_class.new hash
        packet
      rescue => e
        raise MessageLoadError, e
      end
    end

    def each
      if block_given?
        loop do
          yield recv
        end
      end
    end
  end
end
