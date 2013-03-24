require 'msgpack'

module Miu
  module Resources
    class Base
      def to_hash
        {}
      end

      def to_msgpack(*args)
        to_hash.to_msgpack(*args)
      end
    end
  end
end
