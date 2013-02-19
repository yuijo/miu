require 'miu/store'

module Miu
  module Store
    module Strategy
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
      end

      def log(tag, time, record)
        raise NotImplementedError
      end
    end
  end
end
