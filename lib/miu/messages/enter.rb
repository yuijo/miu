require 'miu/resources'
require 'miu/messages/base'

module Miu
  module Messages
    class Enter < Base
      attr_accessor :room, :user

      def initialize(options = {})
        options[:type] ||= 'enter'
        @room = Miu::Utility.adapt(Miu::Resources::Room, options[:room] || {})
        @user = Miu::Utility.adapt(Miu::Resources::User, options[:user] || {})
        super 
      end

      def to_h
        super.merge({
          :room => @room.to_h,
          :user => @user.to_h,
        })
      end
    end

    register :enter, Enter
  end
end
