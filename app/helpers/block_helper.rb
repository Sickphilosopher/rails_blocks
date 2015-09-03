require 'rails_blocks/names'
require 'rails_blocks/path'

module BlockHelper
	include RailsBlocks::Path
	include RailsBlocks::Names
	
	BEM_KEYS = [:tag, :class, :attrs, :mods, :mix, :data]
	
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
		
		content = block_given? ? capture(&block) : nil
		return content if options[:only_context] #for partial with only elements
		@attrs = {class: classes.join(' ')}
		@attrs.merge! options[:attrs] if options[:attrs]
		@attrs.merge! Hash[options[:data].map{|k,v| ["data-#{k}", v]}] if options[:data]
		@props = options.except(BEM_KEYS)
		@attrs[:tag] = options[:tag] || 'div'
		result = template.nil? ? empty(content) : render(file: template, locals: {content: content})
		pop_context_block
		result
	end
	
	def b_context(b_name, &block)
		push_context_block b_name
		result = capture(&block)
		pop_context_block
		result
	end
	
	def e(e_name, options = {}, &block)
		raise RailsBlocks::NoBlockContextError if (parent_block = context_block).nil?
		options = page_options.merge options
		options[:parent_block] = parent_block
		template = element_template parent_block, e_name, options
		classes = element_classes(parent_block, e_name, options)
		
		content = block_given? ? capture(&block) : nil
		@attrs = {class: classes.join(' ')}
		@props = options.except(BEM_KEYS)
		@attrs[:tag] = options[:tag] || 'div'
		@attrs.merge! options[:attrs] if options[:attrs]
		
		template.nil? ? empty(content) : render(file: template, locals: {content: content})
	end
	
	def empty(content)
		atrrs = @attrs.except(:tag).map do |key, value|
			key.to_s + '="' + value.to_s + "\""
		end
		"<#{@attrs[:tag]} #{atrrs.join(' ')}>#{content}</#{@attrs[:tag]}>".html_safe
	end
	
	def bem_attrs
		@attrs
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