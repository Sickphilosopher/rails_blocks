module BlockHelper
	include RailsBlocks::Path

	def b(b_name, options = {}, &block)
		template = find_template b_name, options
		@blocks_stack = @blocks_stack || []
		@blocks_stack.push(b_name)
		
		if block_given?
			@content = capture(&block)
		end
		
		@attrs = {}
		@attrs[:class] = block_classes b_name, options
		if template.nil?
			result = empty
		else
			@attrs[:tag] = options[:tag] || 'div'
			result = render(file: template)
		end
		@blocks_stack.pop
		result
	end
	
	def e(e_name, options = {}, &block)
		@content = capture(&block)
		@attrs = {class: element_classes(@blocks_stack.last, e_name)}
		empty
	end
	
	def empty
		atrrs = @attrs.map {|key, value| key.to_s + '="' + value.to_s + "\""}.join(' ')
		"<div #{atrrs}>#{content}</div>".html_safe
	end
	
	def bem_attrs
		@attrs
	end
	
	def content
		@content
	end
	
	private
	
		def element_classes(b_name, e_name)
			classes = [element_class(b_name, e_name)]
			classes.join(' ')
		end
		
		def block_classes(b_name, options)
			base_class = block_class(b_name)
			classes = [base_class]
			classes << mods_classes(base_class, options[:mods]) unless options[:mods].nil?
			classes << mix_class(options[:mix]) unless options[:mix].nil?
			classes.join(' ')
		end
	
		def add_mods(block_dir, b_name, mods)
			mod, value = mods.first
			mod_s = "_#{mod.to_s}_#{value.to_s}"
			dir = File.join block_dir, mod_s
			filename = b_name + mod_s
			return dir, filename
		end
		
		def mods_classes(base_class, mods)
			mods.map {|key, value| base_class + RailsBlocks.config.modifier_separator + key.to_s + '_' + value.to_s}
		end
		
		def mix_class(mix)
			#todo сделать очевиднее
			element_class(@blocks_stack[@blocks_stack.length - 2], mix[:e])
		end
		
		def block_class(b_name)
			RailsBlocks.config.prefix + b_name
		end
		
		def element_class(b_name, e_name)
			block_class(b_name) + RailsBlocks.config.element_separator + e_name
		end
		
		def find_template(b_name, options = {})
			block_dir = get_block_dir b_name
			return nil if block_dir.nil?
			
			unless options[:mods].nil?
				block_dir_with_mod, filename = add_mods(block_dir, b_name, options[:mods])
				path = File.join block_dir_with_mod, filename + RailsBlocks.config.template_engine
				if File.exists? path
					return path
				end
			end
			filename = b_name
			path = File.join block_dir, filename + RailsBlocks.config.template_engine
			if File.exists? path
				return path
			end
		end
		
		def get_block_dir(b_name)
			RailsBlocks.config.levels.reverse.each do |level|
				block_dir = File.join(blocks_dir, level, b_name)
				if Dir.exists? block_dir
					return block_dir
				end
			end
			nil
		end
end