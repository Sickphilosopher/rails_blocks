# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_blocks/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_blocks"
  spec.version       = RailsBlocks::VERSION
  spec.authors       = ["Andrey Potetiurin"]
  spec.email         = ["potetiurin@gmail.com"]
  spec.summary       = "Rails plugin for work with some modification of BEM methodology"
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
