require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Unknown < Base
      attr_accessor :value

      def initialize(options = {})
        options[:type] ||= 'unknown'
        @value = options[:value]
        super
      end

      def to_h
        super.merge({
          :value => @value
        })
      end
    end
  end
end
