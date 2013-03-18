require 'miu/resources/base'

module Miu
  module Resources
    class User < Base
      attr_accessor :name

      def initialize(options = {})
        @name = options[:name]
      end

      def to_hash
        super.merge({:name => @name})
      end
    end
  end
end
