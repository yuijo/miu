require 'msgpack'

module Miu
  module Resources
    class Base
      def to_h
        {}
      end

      def to_msgpack(*args)
        to_h.to_msgpack(*args)
      end
    end
  end
end
