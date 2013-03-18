require 'msgpack'

module Miu
  module Resources
    class Base
      def to_hash
        {}
      end

      def to_msgpack
        to_hash.to_msgpack
      end
    end
  end
end
