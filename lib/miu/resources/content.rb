require 'miu/resources'

module Miu
  module Resources
    class Content < Base
      attr_accessor :raw
      attr_accessor :meta

      def initialize(options = {})
        @meta = options[:meta] || {}
      end

      def to_hash
        super.merge({:meta => @meta})
      end
    end
  end
end
