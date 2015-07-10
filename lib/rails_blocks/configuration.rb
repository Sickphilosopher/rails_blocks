module RailsBlocks
	class Configuration
		attr_accessor :prefix
		attr_accessor :blocks_dir
		
		def initialize
			@prefix = 'b-'
			@blocks_dir = 'app/blocks'
		end
	end
end