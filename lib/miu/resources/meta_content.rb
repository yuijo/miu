require 'miu/resources'

module Miu
  module Resources
    class MetaContent < Content
      attr_accessor :meta

      def initialize(options = {})
        @meta = options[:meta] || {}
        super
      end

      def to_h
        super.merge({:meta => @meta})
      end
    end
  end
end
