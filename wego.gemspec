# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wego/version'

Gem::Specification.new do |spec|
  spec.name          = "wego"
  spec.version       = Wego::VERSION
  spec.authors       = ["Guillaume KPOTUFE"]
  spec.email         = ["mcguy2008@gmail.com"]
  spec.summary       = %q{Wego flight Rest API}
  spec.description   = %q{Wego flight REST API for ruby apps}
  spec.homepage      = "http://www.donpepeto.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "rest-client-components"

end
