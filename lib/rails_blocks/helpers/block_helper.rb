module RailsBlocks
	module Helpers
		module BlockHelper
			def b(b_name)
				dir = Rails.root.join('app/blocks')#RailsBlocks.config.blocks_dir
				# block = RailsBlocks.get_block b_name
				# block.render.html_safe
				#dir.to_s
				'bash'
			end
		end
	end
end