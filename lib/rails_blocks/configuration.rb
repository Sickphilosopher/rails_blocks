module RailsBlocks
	class Configuration
		attr_accessor :prefix
		
		def initialize
			@prefix = 'b-'
		end
	end
end