require 'rails_blocks/version'
require 'rails_blocks/blocks/block'
require 'rails_blocks/configuration'
require 'rails_blocks/path'
require 'rails_blocks/engine' if defined?(Rails)

module RailsBlocks
	BLOCKS = []
	include RailsBlocks::Path
	
	class << self
		attr_writer :config
	end
	
	def self.config
		@config ||= Configuration.new
	end
	
	def self.configure
		yield(config)
	end
	
	def self.get_block(b_name)
		Blocks::Block.new(b_name)
	end
	
	def self.reset
		@config = Configuration.new
	end
end
