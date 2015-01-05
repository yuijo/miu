require 'miu/version'

module Miu
  DEFAULT_FRONTEND_ADDRESS = 'tcp://127.0.0.1:22200'
  DEFAULT_BACKEND_ADDRESS = 'tcp://127.0.0.1:22201'

  autoload :Hub, 'miu/hub'
  autoload :Tail, 'miu/tail'
end
