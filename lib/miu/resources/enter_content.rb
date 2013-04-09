require 'miu/resources'

module Miu
  module Resources
    class EnterContent < Content
      attr_accessor :room, :user

      def initialize(options = {})
        @room = Miu::Utility.adapt(Room, options[:room] || {})
        @user = Miu::Utility.adapt(User, options[:user] || {})
        super options
      end

      def to_hash
        super.merge({
          :room => @room.to_hash,
          :user => @user.to_hash,
        })
      end
    end
  end
end
