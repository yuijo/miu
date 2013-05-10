require 'miu/resources'

module Miu
  module Resources
    class LeaveContent < Content
      attr_accessor :room, :user

      def initialize(options = {})
        @room = Miu::Utility.adapt(Room, options[:room] || {})
        @user = Miu::Utility.adapt(User, options[:user] || {})
        super options
      end

      def to_h
        super.merge({
          :room => @room.to_h,
          :user => @user.to_h,
        })
      end
    end
  end
end
