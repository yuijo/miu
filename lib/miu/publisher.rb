require 'miu'
require 'msgpack'

module Miu
  class Publisher < Socket
    def initialize(options = {})
      options[:port] ||= Miu.default_sub_port
      super socket_type, options

      yield self if block_given?
    end

    # tag, time = nil, body
    def send(*args)
      packet = Packet.new *args
      @socket.send_strings packet.dump
      packet.id
    end

    private

    def socket_type
      if ZMQ::LibZMQ.version3?
        ZMQ::XPUB
      else
        ZMQ::PUB
      end
    end
  end
end
