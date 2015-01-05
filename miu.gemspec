# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'miu/version'

Gem::Specification.new do |spec|
  spec.name          = "miu"
  spec.version       = Miu::VERSION
  spec.authors       = ["mashiro"]
  spec.email         = ["mail@mashiro.org"]
  spec.summary       = %q{Miu message hub}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/yuijo/miu"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi-rzmq"
  spec.add_dependency "msgpack"
  spec.add_dependency "slop"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
