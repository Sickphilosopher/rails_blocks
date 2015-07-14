module RailsBlocks
	class Configuration
		attr_accessor :prefix
		attr_accessor :blocks_dir
		attr_accessor :levels
		
		def initialize
			@prefix = 'b-'
			@blocks_dir = 'app/blocks'
			@levels = []
		end
	end
end