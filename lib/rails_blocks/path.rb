module RailsBlocks
	module Path
		def gem_path
			@gem_path ||= File.expand_path '..', File.dirname(__FILE__)
		end

		def stylesheets_path
			File.join assets_path, 'stylesheets'
		end

		def fonts_path
			File.join assets_path, 'fonts'
		end

		def javascripts_path
			File.join assets_path, 'javascripts'
		end

		def assets_path
			@assets_path ||= File.join gem_path, 'assets'
		end
		
		def blocks_dir
			Rails.root.join RailsBlocks.config.blocks_dir
		end
		
		def block_template(b_name, options = {})
			block_dir = get_block_dir b_name, options[:levels]
			return nil if block_dir.nil?
			
			if options[:mods]
				path = File.join block_dir, b_name + mod(options[:mods]) + RailsBlocks.config.template_engine
				return path if File.exists? path
			end
			
			filename = b_name
			path = File.join block_dir, filename + RailsBlocks.config.template_engine
			if File.exists? path
				return path
			end
		end
		
		def element_template(b_name, e_name, options = {})
			block_dir = get_block_dir b_name, options[:levels]
			return nil if block_dir.nil?
			
			if options[:mods]
				path = File.join block_dir, RailsBlocks.config.element_separator + e_name + mod(options[:mods]) + RailsBlocks.config.template_engine
				return path if File.exists? path
			end
			
			return path if File.exists? path = File.join(block_dir, RailsBlocks.config.element_separator + e_name + RailsBlocks.config.template_engine)
		end
		
		private
			def get_block_dir(b_name, levels)
				levels.reverse.each do |level|
					block_dir = File.join(blocks_dir, level, b_name)
					if Dir.exists? block_dir
						return block_dir
					end
				end
				nil
			end
		
			def mod(mods)
				mod, value = mods.first
				"_#{mod.to_s}_#{value.to_s}"
			end
	end
end