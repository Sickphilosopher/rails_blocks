module RailsBlocks
	module Levels
		def add_view_paths
			prepend_view_path RailsBlocks::Path.blocks_dir
		end
	end
end