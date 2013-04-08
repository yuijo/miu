module Miu
  module Messages
    class << self
      def types
        @types ||= {}
      end

      def register(type, klass)
        types[type.to_s] = klass
      end

      def guess(type)
        types[type.to_s] || Unknown
      end
    end
  end
end

require 'miu/messages/base'
require 'miu/messages/unknown'
require 'miu/messages/text'
