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
	end
end