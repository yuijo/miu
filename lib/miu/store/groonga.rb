require 'miu/store/base'

module Miu
  module Store
    class Groonga < Base
      def initialize(options)
        require 'groonga'
        migrate options
      end

      def migrate(options)
        ::Groonga::Context.default_options = {:encoding => :utf8}
        path = options[:database]

        if File.exist? path
          ::Groonga::Database.open path
        else
          ::Groonga::Database.create :path => path
        end

        ::Groonga::Schema.define do |schema|
          schema.create_table 'targets', :type => :patricia_trie, :key_type => :short_text
          schema.create_table 'users', :type => :patricia_trie, :key_type => :short_text
          schema.create_table 'messages', :type => :array
          schema.create_table 'terms', :type => :patricia_trie, :normalizer => :NormalizerAuto, :default_tokenizer => 'TokenBigram'

          schema.change_table 'targets' do |table|
          end
          schema.change_table 'users' do |table|
          end
          schema.change_table 'messages' do |table|
            table.reference 'target', 'targets'
            table.reference 'sender', 'users'
            table.short_text 'text'
            table.short_text 'type'
            table.time 'created_at'
          end
          schema.change_table 'terms' do |table|
            table.index 'messages.text'
          end
        end
      end

      def add(msg)
        p msg
        'OK'

        # if m.channel && m.user
        #   target = $targets[m.channel.name] || $targets.add(m.channel.name)
        #   user = $users[m.user.name] || $users.add(m.user.name)
        #   message = $messages.add({
        #     :target => target,
        #     :sender => user,
        #     :text => m.message,
        #     :type => 'PRIVMSG',
        #     :created_at => Time.now,
        #   })
        # end
      end
    end
  end
end
