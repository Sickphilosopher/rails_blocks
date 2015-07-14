module BlockHelper
	include RailsBlocks::Path
	def b(b_name, options = {})
		dir = b_name
		target = [dir, b_name].join('/').gsub!('-', '_')
		# block = RailsBlocks.get_block b_name
		# block.render.html_safe
		#dir.to_s
		template_exists?(target) ? render(file: target) : empty
	end
	
	def empty
		'test empty'
	end
end