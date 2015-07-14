module BlockHelper
	include RailsBlocks::Path
	def b(b_name, options = {})
		dir = b_name
		filename = b_name
		dir, filename = add_mods(dir, filename, options)
		target = [dir, filename].join('/').gsub!('-', '_')
		# block = RailsBlocks.get_block b_name
		# block.render.html_safe
		#dir.to_s
		
		template_exists?(target) ? render(file: target) : empty
	end
	
	def empty
		'test empty'
	end
	
	private
		def add_mods(dir, filename, options = {})
			unless(options[:mods].nil?)
				mod, value = options[:mods].first
				mod_s = "_#{mod.to_s}_#{value.to_s}"
				dir = File.join dir, mod_s
				filename += mod_s
			end
			return dir, filename
		end
end