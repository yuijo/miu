require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Unknown < Base
      def initialize(options = {})
        options[:type] ||= 'unknown'
        options[:content] = Miu::Utility.adapt(Resources::UnknownContent, options[:content] || {})
        super
      end
    end
  end
end
