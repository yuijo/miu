require 'miu/socket'
require 'miu/packet'
require 'ffi-rzmq'

module Miu
  class Publisher < Socket
    def initialize(options = {})
      options[:socket_type] ||= ZMQ::PUB
      options[:port] ||= Miu.default_sub_port
      super options

      yield self if block_given?
    end

    def send(tag, message)
      packet = Packet.new tag, message
      @socket.send_strings packet.dump
      packet
    end
  end
end
