# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miu/version'

Gem::Specification.new do |gem|
  gem.name          = "miu"
  gem.version       = Miu::VERSION
  gem.authors       = ["mashiro"]
  gem.email         = ["mail@mashiro.org"]
  gem.description   = %q{miu miu}
  gem.summary       = %q{miu miu}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'thor', '>= 0.18.1'
  gem.add_dependency 'god', '>= 0.13.2'
  gem.add_dependency 'ffi-rzmq', '>= 1.0.0'
  gem.add_dependency 'msgpack', '>= 0.5.4'
  gem.add_development_dependency 'rake', '>= 10.0.4'
  gem.add_development_dependency 'rspec', '>= 2.13.0'
  gem.add_development_dependency 'celluloid-zmq', '>= 0.13.0'
end
