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
		options = page_options.merge options
		options[:parent_block] = context_block
		push_context_block b_name
		template = block_template b_name, options
		result = entity(template, :block, b_name, options, &block)
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
		options = page_options.merge options
		parent_block = options[:b] || context_block
		raise RailsBlocks::NoBlockContextError unless parent_block
		options[:parent_block] = parent_block
		template = element_template parent_block, e_name, options
		entity(template, :elem, e_name, options, &block)
	end
	
	def e_classes(e_name, options = {})
		parent_block = options[:b] || context_block
		raise RailsBlocks::NoBlockContextError unless parent_block
		options = page_options.merge options
		options[:parent_block] = parent_block
		element_classes(parent_block, e_name, options).join(' ')
	end
	
	def entity(template, type, name, options, &block)
		content = block ? capture(&block) : options[:content]
		#важно заполнять публичные поля только после того, как закапчюрится то, что внутри энтити, иначе они перезапишутся.
		@attrs = nil
		@current_options = options
		@current_entity = {type: type, name: name}
		template.nil? ? empty(content) : render(file: template, locals: {content: content, options: options})
	end
	
	def empty(content)
		content_tag bem_tag, content, bem_attrs_without_tag
	end
	
	def bem_tag
		bem_attrs[:tag]
	end
	
	def bem_attrs
		if @attrs.nil?
			@attrs = {class: current_entity_classes.join(' ')}
			@attrs.merge! @current_options[:attrs] if @current_options[:attrs]
			data = current_bem_data
			@attrs['data-bem'] = data.to_json if data
			@attrs[:tag] = @current_options[:tag] || 'div'
		end

		@attrs
	end
	
	def bem_attrs_without_tag
		bem_attrs.except :tag
	end

	def set_tag(tag)
		@current_options[:tag] = tag
	end

	def set_js(value)
		@current_options[:js] = value
	end
	
	private
		def current_bem_data
			data = {}
			data.merge! entity_data(current_entity_name, @current_options[:js]) if @current_options[:js]
			data.merge! mix_data(@current_options[:mix]) if @current_options[:mix]

			return nil if data == {}
			data
		end

		def mix_data(mixes)
			mixes = [mixes] unless mixes.is_a? Array
			data = mixes.map do |mix|
				next unless mix[:js]
				if mix[:e]
					if mix[:b]
						entity_data(element_name(mix[:b], mix[:e]), mix[:js])
					else
						entity_data(element_name(context_block, mix[:e]), mix[:js])
					end
				else
					raise RailsBlocks::BadMixError if mix[:b].nil?
					entity_data(block_name(mix[:b]), mix[:js])
				end
			end.compact.inject(&:merge) || {}
		end

		def entity_data(name, data)
			return {name => data} if data.is_a? Hash
			return {name => {}} if data == true
			{}
		end

		def current_entity_name
			return block_name(@current_entity[:name]) if @current_entity[:type] == :block
			element_name(@current_options[:parent_block], @current_entity[:name])
		end

		def current_entity_classes
			return block_classes(@current_entity[:name], @current_options) if @current_entity[:type] == :block
			element_classes(@current_options[:parent_block], @current_entity[:name], @current_options)
		end

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