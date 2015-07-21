module RailsBlocks
	class Configuration
		attr_accessor :prefix
		attr_accessor :blocks_dir
		attr_accessor :levels
		attr_accessor :template_engine
		attr_accessor :element_separator
		attr_accessor :modifier_separator
		
		def initialize
			@prefix = 'b-'
			@blocks_dir = 'app/blocks'
			@levels = []
			@template_engine = '.slim'
			@element_separator = '__'
			@modifier_separator = '--'
		end
	end
end