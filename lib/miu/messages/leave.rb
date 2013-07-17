require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Leave < Base
      attr_accessor :room, :user

      def initialize(options = {})
        options[:type] ||= 'leave'
        @room = Utility.adapt(Resources::Room, options[:room] || {})
        @user = Utility.adapt(Resources::User, options[:user] || {})
        super 
      end

      def to_h
        super.merge({
          :room => @room.to_h,
          :user => @user.to_h,
        })
      end
    end

    register :leave, Leave
  end
end
