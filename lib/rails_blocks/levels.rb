module RailsBlocks
	module Levels
		extend RailsBlocks::Path
		def self.get_levels
			Dir.glob(blocks_dir + '/*/').each do |level|
				RailsBlocks.add_level(level)
			end
		end
	end
end