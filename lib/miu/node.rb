require 'miu'

module Miu
  module Node
    def self.included(base)
      STDOUT.sync = true
      STDERR.sync = true
      base.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :spec

      def description(value = nil)
        @description ||= self.name
        @description = value if value
        @description
      end

      def register(*args, &block)
        options = Miu::Utility.extract_options!(args)
        name = args.shift
        node = args.shift || self
        Miu.register name, node, options, &block
      end
    end
  end
end