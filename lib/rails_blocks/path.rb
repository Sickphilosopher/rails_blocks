module RailsBlocks
	module Path
		
		def blocks_dir
			Rails.root.join RailsBlocks.config.blocks_dir
		end
		
		def block_template(b_name, options = {})
			options[:levels].reverse.each do |level|
				p level
				p b_name
				p RailsBlocks.tree
				next unless RailsBlocks.tree[level][b_name]
				return RailsBlocks.tree[level][b_name][mod(options)] if RailsBlocks.tree[level][b_name][mod(options)]
				return RailsBlocks.tree[level][b_name]['']
			end
			nil
		end
		
		def element_template(b_name, e_name, options = {})
			options[:levels].reverse.each do |level|
				next unless RailsBlocks.tree[level][b_name]
				return RailsBlocks.tree[level][b_name]["_#{e_name}"] if RailsBlocks.tree[level][b_name]["_#{e_name}"]
			end
			nil
		end
		
		private
			
			def mod(options)
				return '' unless options[:mods] && !options[:mods].empty?
				mod_class(*options[:mods].first)
			end
			
			def mod_path(dir, name, options)
				return nil unless options[:mods]
				path = File.join dir, name + '_' + mod_class(*options[:mods].first) + RailsBlocks.config.template_engine
				File.exists?(path) ? path : nil
			end
			
			def get_block_dir(b_name, levels)
				levels.reverse.each do |level|
					block_dir = File.join(blocks_dir, level, b_name)
					if Dir.exists? block_dir
						return block_dir
					end
				end
				nil
			end
	end
end