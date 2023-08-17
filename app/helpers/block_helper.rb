require 'rails_blocks/names'
require 'rails_blocks/path'

class RenderContext
	attr_accessor :slots, :rendered_slots
	def initialize
		@slots = {}
		@rendered_slots = {}
	end

	def slot(name, &block)
		slots[name] = block
	end
end

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
		push_context_block b_name, options
		template = block_template b_name, options
		result = entity(template, :block, b_name, options, &block)
		pop_context_block
		result
	end
	
	def b_classes(b_name, options = {})
		parent_block = context_block
		push_context_block b_name, options
		options = page_options.merge options
		options[:parent_block] = parent_block if parent_block
		classes = block_classes b_name, options
		pop_context_block
		classes
	end
	
	def b_context(b_name, options = {}, &block)
		push_context_block b_name, options
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
		ctx = RenderContext.new
		content = block ? capture(ctx, &block) : options[:content]
		ctx.slots.each {|k, v| ctx.rendered_slots[k] = capture(&v)}
		#важно заполнять публичные поля только после того, как закапчюрится то, что внутри энтити, иначе они перезапишутся.
		@attrs = nil
		@current_options = options
		@current_entity = {type: type, name: name}
		template.nil? ? empty(content) : render(template: template, locals: {content: content, options: options, slots: ctx.rendered_slots})
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

	def set_mod(name, value)
		@current_options[:mods] ||= {}
		@current_options[:mods][name] = value
	end

	def add_mix(mix)
		@current_options[:mix] ||= []
		return @current_options[:mix].push(mix) if mix.is_a? Hash
		@current_options[:mix].push(*mix) if mix.is_a? Array
	end
	
	private
		def current_bem_data
			data = {}
			if(@current_entity[:type] == :block)
				data.merge! block_data(@current_entity[:name], @current_options[:js])
			else
				data.merge! element_data(context_block, @current_entity[:name], @current_options[:js])
			end
			data.merge! mix_data(@current_options[:mix]) if @current_options[:mix]

			return nil if data.length == 0
			data
		end

		def mix_data(mixes)
			mixes = [mixes] unless mixes.is_a? Array
			data = mixes.map do |mix|
				next unless mix[:js]
				if mix[:e]
					element_data(mix[:b] || context_block, mix[:e], mix[:js])
				else
					raise RailsBlocks::BadMixError if mix[:b].nil?
					block_data(mix[:b], mix[:js])
				end
			end.compact.inject(&:merge) || {}
		end

		def block_data(name, js)
			level = block_js_level(context_block, @current_options[:levels])
			return {} if !js
			data = (js == true ? {} : js).merge!({level: level, js_ext: block_js_ext(context_block, level)})
			entity_data(name, data)
		end

		def element_data(b, e, js)
			entity_data(element_name(b || context_block, e), js)
		end

		def entity_data(name, data)
			if data.is_a? Hash
				transformed_data = data.transform_keys {|k| k.to_s.camelize(:lower)}
				return {name => transformed_data}
			end
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
			blocks_stack.last&.fetch(:name, nil)
		end

		def context_block_options
			blocks_stack.last&.fetch(:options, nil)
		end
		
		def push_context_block(b_name, options)
			blocks_stack.push({name: b_name, options: options})
		end
		
		def pop_context_block
			blocks_stack.pop
		end
end