require 'miu/packet'

module Miu
  module Writable
    def self.included(base)
      base.class_eval do
        def write_with_packet(tckag, message)
          packet = Packet.new tckag, message
          write_without_packet *packet.dump
          packet
        end

        alias_method :write_without_packet, :write
        alias_method :write, :write_with_packet
      end
    end
  end
end
