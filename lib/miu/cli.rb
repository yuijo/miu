require 'thor'
require 'miu'

module Miu
  class CLI < Thor
    map ['--version', '-v'] => :version

    desc 'version', 'Show version'
    def version
      say "Miu #{Miu::VERSION}"
    end
  end
end
