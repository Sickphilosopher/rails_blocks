module RailsBlocks
	module Helpers
		module BlockHelper
			def b(b_name)
				block = RailsBlocks.get_block b_name
				block.render.html_safe
			end
		end
	end
end