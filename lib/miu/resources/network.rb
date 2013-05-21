require 'miu/resources'

module Miu
  module Resources
    class Network < Base
      attr_accessor :name
      attr_accessor :input, :output

      def initialize(options = {})
        @name = options[:name]
        @input = options[:input]
        @output = options[:output]
        super
      end

      def to_h
        hash = super
        hash[:name] = @name
        hash[:input] = @input if @input
        hash[:output] = @output if @output
        hash
      end
    end
  end
end
