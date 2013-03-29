require 'thor'

module Miu
  class CLIBase < ::Thor
    include ::Thor::Actions
  end
end
