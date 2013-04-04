require 'miu/packet'
require 'miu/messages'

module Miu
  module Subscribable
    def self.included(base)
      base.class_eval do
        def read_with_packet
          parts = []
          loop do
            parts << read_without_packet
            break unless more_parts?
          end

          packet = Packet.load parts
          begin
            data = Miu::Utility.symbolize_keys(packet.data, true) rescue packet.data
            type = data[:type] rescue nil
            message_class = Miu::Messages.guess(type)
            packet.data = message_class.new data
            packet
          rescue => e
            raise MessageLoadError, e
          end
        end

        alias_method :read_without_packet, :read
        alias_method :read, :read_with_packet
      end

      base.send :include, ::Enumerable
    end

    def each
      if block_given?
        loop do
          yield read
        end
      end

      return self
    end
  end
end
