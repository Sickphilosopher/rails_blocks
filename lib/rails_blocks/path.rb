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
			
			path = mod_path(block_dir, b_name, options)
			return path if path
			
			filename = b_name
			path = File.join block_dir, filename + RailsBlocks.config.template_engine
			if File.exists? path
				return path
			end
		end
		
		def element_template(b_name, e_name, options = {})
			block_dir = get_block_dir b_name, options[:levels]
			return nil if block_dir.nil?
			
			path = mod_path(block_dir, RailsBlocks.config.element_separator + e_name, options)
			return path if path

			return path if File.exists? path = File.join(block_dir, RailsBlocks.config.element_separator + e_name + RailsBlocks.config.template_engine)
		end
		
		private
		
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