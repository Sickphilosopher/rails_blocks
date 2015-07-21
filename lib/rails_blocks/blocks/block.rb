require 'rails_blocks/blocks/renderer'
module RailsBlocks
	module Blocks
		class Block
			include Blocks::Renderer
			attr_accessor :name
			attr_accessor :options
			attr_accessor :content
			
			def initialize(name)
				@name = name
			end
			
			def render
				".#{klass}\n\t#{render_content}"
			end
			
			def render_content
				instance_eval &content
			end
			
			
			def klass
				RailsBlocks.config.prefix + @name
			end
		end
	end
end