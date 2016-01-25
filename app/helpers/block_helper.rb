require 'rails_blocks/names'
require 'rails_blocks/path'

module BlockHelper
	include RailsBlocks::Path
	include RailsBlocks::Names
	
	BEM_KEYS = [:tag, :class, :attrs, :mods, :mix, :data, :levels, :content]
	
	def bem_page(options, &block)
		@page_options = options
		block_given? ? capture(&block) : ''
	end
	
	def page_options
		defaults = {
			levels: RailsBlocks.config.levels
		}
		defaults.merge @page_options || {}
	end
	
	#TODO бога ради, отрефактори это дерьмо
	def b(b_name, options = {}, &block)
		parent_block = context_block
		push_context_block b_name
		options = page_options.merge options
		options[:parent_block] = parent_block if parent_block
		template = block_template b_name, options
		classes = block_classes b_name, options
		
		result = element(classes, template, options, &block)
		pop_context_block
		result
	end
	
	def b_classes(b_name, options = {})
		parent_block = context_block
		push_context_block b_name
		options = page_options.merge options
		options[:parent_block] = parent_block if parent_block
		classes = block_classes b_name, options
		pop_context_block
		classes
	end
	
	def b_context(b_name, &block)
		push_context_block b_name
		result = capture(&block)
		pop_context_block
		result
	end
	
	def e(e_name, options = {}, &block)
		parent_block = options[:b] || context_block
		raise RailsBlocks::NoBlockContextError unless parent_block
		options = page_options.merge options
		options[:parent_block] = parent_block
		template = element_template parent_block, e_name, options
		classes = element_classes(parent_block, e_name, options)
		element(classes, template, options, &block)
	end
	
	def e_classes(e_name, options = {})
		parent_block = options[:b] || context_block
		raise RailsBlocks::NoBlockContextError unless parent_block
		options = page_options.merge options
		options[:parent_block] = parent_block
		element_classes(parent_block, e_name, options).join(' ')
	end
	
	def element(classes, template, options, &block)
		content = block ? capture(&block) : options[:content]
		@attrs = {class: classes.join(' ')}
		@attrs.merge! options[:attrs] if options[:attrs]
		@attrs["data-bem"] = options[:data].to_json if options[:data]
		@attrs[:tag] = options[:tag] || 'div'
		
		template.nil? ? empty(content) : render(file: template, locals: {content: content, options: options})
	end
	
	#убрать после тестов производительности
	# def empty(content)
	# 	atrrs = @attrs.except(:tag).map do |key, value|
	# 		key.to_s + '=\'' + value.to_s + "'"
	# 	end
	# 	"<#{@attrs[:tag]} #{atrrs.join(' ')}>#{content}</#{@attrs[:tag]}>".html_safe
	# end
	
	def empty(content)
		content_tag bem_tag, content, bem_attrs_without_tag
	end
	
	def bem_tag
		@attrs[:tag]
	end
	
	def bem_attrs
		@attrs
	end
	
	def bem_attrs_without_tag
		@attrs.except :tag
	end
	
	private
		
		def blocks_stack
			@blocks_stack = @blocks_stack || []
		end
		
		def context_block
			blocks_stack.last
		end
		
		def push_context_block(b_name)
			blocks_stack.push b_name
		end
		
		def pop_context_block
			blocks_stack.pop
		end
end