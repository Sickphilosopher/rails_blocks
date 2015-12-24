module RailsBlocks
	module Levels
		def add_view_paths
			prepend_view_path RailsBlocks.blocks_dir
		end
	end
end