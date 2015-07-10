module BlockHelper
	include RailsBlocks::Path
	def b(b_name, options = {})
		dir = File.join blocks_dir, b_name
		template = b_name
		target = [dir, template].join('/')
		# block = RailsBlocks.get_block b_name
		# block.render.html_safe
		#dir.to_s
		template_exists?(target) ? render(file: target) : empty
		(File.exists?(target + '.slim')).to_s
		target
	end
	
	def empty
		'test empty'
	end
end