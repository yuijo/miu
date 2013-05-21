require 'miu/resources'

module Miu
  module Resources
    class EnterContent < Content
      attr_accessor :room, :user

      def initialize(options = {})
        @room = Miu::Utility.adapt(Room, options[:room] || {})
        @user = Miu::Utility.adapt(User, options[:user] || {})
        super
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
