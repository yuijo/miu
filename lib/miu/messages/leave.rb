require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Leave < Base
      def initialize(options = {})
        options[:type] ||= 'leave'
        options[:content] = Miu::Utility.adapt(Resources::LeaveContent, options[:content] || {})
        super 
      end
    end

    register :leave, Leave
  end
end
