module RailsBlocks
	module Blocks
		class Block
			attr_accessor :name
			
			def initialize(name)
				@name = name
			end
			
			def render
				"<div class=\"#{klass}\"></div>"
			end
			
			def klass
				RailsBlocks.config.prefix + @name
			end
		end
	end
end