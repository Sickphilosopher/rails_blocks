module RailsBlocks
	module Levels
		def add_view_paths
			RailsBlocks.config.levels.reverse.each do |level|
				prepend_view_path File.join(RailsBlocks.config.blocks_dir, level)
			end
			prepend_view_path RailsBlocks.blocks_dir
		end
	end
end