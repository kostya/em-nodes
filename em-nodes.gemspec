# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'em-nodes/version'

Gem::Specification.new do |spec|
  spec.name          = "em-nodes"
  spec.version       = EventMachine::Nodes::VERSION
  spec.authors       = ["'Konstantin Makarchev'"]
  spec.email         = ["'kostya27@gmail.com'"]
  spec.summary       = %q{Simple EM client server, and some stuffs}
  spec.description   = %q{Simple EM client server, and some stuffs}
  spec.homepage      = "https://github.com/kostya/em-nodes"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "eventmachine"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
