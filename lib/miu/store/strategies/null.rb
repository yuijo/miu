require 'miu/store/strategy'

module Miu
  module Store
    module Strategies
      class Null
        include Miu::Store::Strategy

        def log(tag, time, record)
        end
      end
    end

    register :null, Strategies::Null
  end
end
