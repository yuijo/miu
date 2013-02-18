require 'thor'
require 'miu'
require 'miu/store'

module Miu
  class CLI < Thor
    include Thor::Actions

    class << self
      def source_root
        Miu.root
      end
    end

    map ['--version', '-v'] => :version

    desc 'version', 'Show version', :hide => true
    def version
      say "Miu #{Miu::VERSION}"
    end

    desc 'store', 'Start miu store server'
    option :config, :type => :string, :desc => 'config file', :aliases => '-c'
    option :address, :type => :string, :default => '0.0.0.0', :desc => 'bind address', :aliases => '-a'
    option :port, :type => :numeric, :default => 30301, :desc => 'listen port', :aliases => '-p'
    option :type, :type => :string, :default => 'groonga', :desc => 'store type', :aliases => '-t'
    option :database, :type => :string, :default => 'db/miu.db', :desc => 'database'
    def store
      apply options[:config] if options[:config]
      Miu::Store.start options
    end
  end
end
