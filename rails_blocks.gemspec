# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_blocks/version'

Gem::Specification.new do |spec|
	spec.name					= 'rails_blocks'
	spec.version			 = RailsBlocks::VERSION
	spec.authors			 = ['Andrey Potetiurin']
	spec.email				 = ['potetiurin@gmail.com']
	spec.summary			 = 'Rails plugin for work with some modification of BEM methodology'
	spec.description	 = 'Gem helps build UI with blocks approach'
	spec.homepage			= ''
	spec.license			 = 'MIT'

	spec.files				 = `git ls-files -z`.split("\x0")
	spec.executables	 = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files		= spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_dependency 'rails', '~> 4.2', '>= 4.2.3'
	#testing
	spec.add_development_dependency 'combustion', '~> 0.5.3'
	spec.add_development_dependency 'bundler', '~> 1.7'
	spec.add_development_dependency 'rspec', '~> 3.3'
	spec.add_development_dependency 'rspec-nc'
	spec.add_development_dependency 'capybara'
	spec.add_development_dependency 'rspec-rails', '~> 3.0'
	spec.add_development_dependency 'memfs'
	spec.add_development_dependency 'spring'
	spec.add_development_dependency 'guard'
	spec.add_development_dependency 'guard-rspec'
	spec.add_development_dependency 'pry'
	spec.add_development_dependency 'pry-remote'
	spec.add_development_dependency 'pry-nav'
	spec.add_development_dependency 'terminal-notifier'
	spec.add_development_dependency 'terminal-notifier-guard'
end
