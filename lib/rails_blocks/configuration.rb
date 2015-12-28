module RailsBlocks
	class Configuration
		attr_accessor :prefix
		attr_accessor :blocks_dir
		attr_accessor :levels
		attr_accessor :template_engine
		attr_accessor :element_separator
		attr_accessor :modifier_separator
		attr_accessor :js_class
		
		def ns(name)
			@ns ||= {}
			ns_config = @ns[name] ||= Configuration.new
			yield ns_config
		end
		
		def initialize
			@prefix = 'b-'
			@blocks_dir = 'app/blocks'
			@levels = []
			@template_engine = '.slim'
			@element_separator = '__'
			@modifier_separator = '--'
			@js_class = 'js_bem'
		end
	end
end