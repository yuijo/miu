require 'miu/resources'

module Miu
  module Resources
    class Room < Base
      attr_accessor :name

      def initialize(options = {})
        @name = options[:name]
      end

      def to_h
        super.merge({:name => @name})
      end
    end
  end
end
