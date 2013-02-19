require 'miu/version'
require 'miu/store'
require 'pathname'

module Miu
  class << self
    def root
      Pathname.new(File.expand_path('../../', __FILE__))
    end
  end
end
