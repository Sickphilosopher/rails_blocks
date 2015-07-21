module BlockHelper
	include RailsBlocks::Path
	
	def render_blocks(file)
		load(File.join(Rails.root, 'app', 'views', 'root', file + '.rb'))
		test = "test\n\t| test"
		Slim::Template.new{ test }.render.html_safe
	end
	
	def b(b_name, options = {}, &content)
		dir = b_name
		filename = b_name
		dir, filename = add_mods(dir, filename, options)
		target = [dir, filename].join('/').gsub('-', '_')
		#block = RailsBlocks.get_block b_name
		#Slim::Template.new{ block.render }.render(block).html_safe
		template_exists?(target) ? render(file: target) : target.to_s
	end
	
	def e()
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