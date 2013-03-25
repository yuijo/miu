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
        require 'miu/type'
        type = Miu::Type.new type
        types[type.content_type] || Unknown
      end
    end
  end
end

require 'miu/messages/base'
require 'miu/messages/unknown'
require 'miu/messages/text'
