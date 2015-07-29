module RailsBlocks
	module Names
		def element_classes(b_name, e_name, options = {})
			base_class = element_class b_name, e_name
			classes = [base_class]
			classes << mods_classes(base_class, options[:mods]) unless options[:mods].nil?
			classes << mix_class(options[:mix]) unless options[:mix].nil?
			classes.join(' ')
		end
		
		def block_classes(b_name, options)
			base_class = block_class b_name
			classes = [base_class]
			classes << mods_classes(base_class, options[:mods]) unless options[:mods].nil?
			classes << mix_class(options[:mix]) unless options[:mix].nil?
			classes.join(' ')
		end
		
		def mods_classes(base_class, mods)
			mods.map do |key, value|
				mod = value == :true ? key.to_s : key.to_s + '_' + value.to_s
				base_class + RailsBlocks.config.modifier_separator + mod
			end
		end
		
		def mix_class(mix)
			mix[:e] = [mix[:e]] unless mix[:e].is_a? Array
			mix[:e].map {|e| element_class(@blocks_stack.last, e.to_s)}.join(' ')
		end
		
		def block_class(b_name)
			RailsBlocks.config.prefix + b_name
		end
		
		def element_class(b_name, e_name)
			block_class(b_name) + RailsBlocks.config.element_separator + e_name
		end
	end
end