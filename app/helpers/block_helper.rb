module BlockHelper
	include RailsBlocks::Path
	include RailsBlocks::Blocks
	def b(b_name, options = {}, &block)
		
		dir = b_name
		filename = b_name
		dir, filename = add_mods(dir, filename, options)
		target = [dir, filename].join('/').gsub('-', '_')
		# block = RailsBlocks.get_block b_name
		# block.render.html_safe
		#dir.to_s
		
		Slim::Template.new{ ".test\n	| test"}.render
		template_exists?(target) ? render(file: target) : target.to_s
		block = Block.new('')
		block.render
	end
	
	def empty
		'test empty'
	end
	
	def this
		{tag: 'test', attrs: {class: 'test-class', boo: 'test-boo'}}
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