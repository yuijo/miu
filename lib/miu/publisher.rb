require 'miu'
require 'miu/socket'
require 'miu/packet'

module Miu
  class Publisher < Socket
    def initialize(options = {})
      options[:socket_type] ||= ZMQ::PUB
      options[:port] ||= Miu.default_sub_port
      super options

      yield self if block_given?
    end

    def send(*args)
      packet = Packet.new *args
      @socket.send_strings packet.dump
      packet.id
    end
  end
end
