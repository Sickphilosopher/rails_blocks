require 'rails_blocks/version'
require 'rails_blocks/blocks/block'
require 'rails_blocks/configuration'
require 'rails_blocks/exceptions'
require 'rails_blocks/path'
require 'rails_blocks/engine' if defined?(Rails)

module RailsBlocks
	BLOCKS = []
	NS = []
	
	extend RailsBlocks::Path
		
	class << self
		attr_writer :config
		attr_writer :tree
	end
	
	def self.config
		@config ||= Configuration.new
	end
	
	def self.tree
		@tree ||= (
			t = {}
			p blocks_dir
			Dir["#{blocks_dir}**/*#{RailsBlocks.config.template_engine}"].map do |file|
				file.sub! blocks_dir.to_s + '/', ''
				parts = file.split('/')
				template = {
					level: parts[0],
					block: parts[1],
					file: parts[2].gsub('.slim', '')
				}
				t[template[:level]] ||= {}
				t[template[:level]][template[:block]] ||= {}
				t[template[:level]][template[:block]][get_mod(file)] = file
			end
			t
		)
	end
	
	def self.get_mod(file)
		return '' unless file.include? '_'
		file.match(/_(.*)\./)
		$1
	end
	
	def self.configure
		yield config
	end
	
	def self.reset
		@config = Configuration.new
	end
end
