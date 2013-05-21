require 'miu/resources'

module Miu
  module Resources
    class UnknownContent < Content
      attr_accessor :value

      def initialize(options = {})
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
