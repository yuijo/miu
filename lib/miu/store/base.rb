module Miu
  module Store
    class Base
      def initialize(options)
      end

      def add(msg)
        raise NotImplementedError
      end
    end
  end
end
