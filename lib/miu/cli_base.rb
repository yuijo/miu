require 'miu'
require 'thor'

module Miu
  class CLIBase < ::Thor
    include ::Thor::Actions
    add_runtime_options!
  end
end
