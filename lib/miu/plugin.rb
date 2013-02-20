require 'miu'

module Miu
  module Plugin
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def register(*args, &block)
        args.insert 1, self.class
        Miu.register *args, &block
      end
    end
  end
end
