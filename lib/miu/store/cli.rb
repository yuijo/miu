require 'miu'
require 'miu/store'
require 'miu/cli'

module Miu
  module Store
    class CLI < Thor
      include Thor::Actions

      namespace :store

      class << self
        def source_root
          Miu.root
        end
      end

      desc 'start', 'Start miu store'
      option :config, :type => :string, :desc => 'config file', :aliases => '-c'
      option :address, :type => :string, :default => '0.0.0.0', :desc => 'bind address', :aliases => '-a'
      option :port, :type => :numeric, :default => 30301, :desc => 'listen port', :aliases => '-p'
      option :type, :type => :string, :default => 'groonga', :desc => 'store type', :aliases => '-t'
      option :database, :type => :string, :default => 'db/miu.db', :desc => 'database'
      def start
        apply options[:config] if options[:config]
        Miu::Store.start options
      end
    end
  end

  Miu::CLI.register Miu::Store::CLI, 'store', 'store [COMMAND]', 'Miu store'
end
