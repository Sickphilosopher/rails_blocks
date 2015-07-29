module BlockHelper
	include RailsBlocks::Path
	include RailsBlocks::Names
	
	BEM_KEYS = [:tag, :class, :attrs, :mods, :mix]
	def b(b_name, options = {}, &block)
		@blocks_stack = @blocks_stack || []
		
		template = find_template b_name, options
		
		klass = block_classes b_name, options #eval before change context block
		@blocks_stack.push(b_name)
	
		@content = block_given? ? capture(&block) : nil
		@attrs = {}
		@attrs[:class] = klass
		@attrs.merge! options[:attrs] if options[:attrs]
		@attrs[:tag] = options[:tag] || 'div'
		
		if template.nil?
			result = empty
		else
			result = render(file: template)
		end
		@blocks_stack.pop
		result
	end
	
	def e(e_name, options = {}, &block)
		raise RailsBlocks::NoBlockContext if @blocks_stack.nil? || @blocks_stack.empty?
		@content = block_given? ? capture(&block) : nil
		@attrs = {class: element_classes(@blocks_stack.last, e_name, options)}
		@attrs[:tag] = options[:tag] || 'div'
		
		empty
	end
	
	def empty
		atrrs = @attrs.except(:tag).map {|key, value| key.to_s + '="' + value.to_s + "\""}.join(' ')
		"<#{@attrs[:tag]} #{atrrs}>#{content}</#{@attrs[:tag]}>".html_safe
	end
	
	def bem_attrs
		@attrs
	end
	
	def content
		@content
	end
	
	private
		def add_mods(b_name, mods)
			mod, value = mods.first
			mod_s = "_#{mod.to_s}_#{value.to_s}"
			filename = b_name + mod_s
			return filename
		end
		
		def find_template(b_name, options = {})
			block_dir = get_block_dir b_name
			return nil if block_dir.nil?
			
			unless options[:mods].nil?
				filename = add_mods(b_name, options[:mods])
				path = File.join block_dir, filename + RailsBlocks.config.template_engine
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