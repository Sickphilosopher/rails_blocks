namespace :rails_blocks do
	desc "Rename block(only in blocks folder)"
	task :rename_b, :old_name, :new_name do |_, args|
		puts args
		levels = Dir[RailsBlocks.blocks_dir + '*'].select {|d| File.directory? d}
		
	end
end