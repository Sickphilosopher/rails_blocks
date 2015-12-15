module RailsBlocks
	module Names
		def element_classes(b_name, e_name, options = {})
			base_class = element_class b_name, e_name
			classes(base_class, options)
		end
		
		def block_classes(b_name, options = {})
			base_class = block_class b_name
			classes(base_class, options)
		end
		
		private
			def classes(base_class, options = {})
				classes = [base_class]
				classes |= mods_classes(base_class, options[:mods]) unless options[:mods].nil?
				classes |= mix_classes(options[:mix], options[:parent_block]) if options[:mix]
				classes |= Array(options[:class]) if options[:class]
				classes << RailsBlocks.config.js_class if options[:js]
				classes
			end
			
			def mix_classes(mixes, context_block = nil)
				mixes = [mixes] unless mixes.is_a? Array
				mixes.map do |mix|
					if mix[:e]
						raise RailsBlocks::BadMixError if context_block.nil? && !mix[:b]
						if mix[:b]
							element_classes(mix[:b].to_s, mix[:e].to_s, mix)
						else
							element_classes(context_block, mix[:e].to_s, mix)
						end
					else
						raise RailsBlocks::BadMixError if mix[:b].nil?
						block_classes(mix[:b].to_s, mix)
					end
				end.inject(&:|)
			end
			
			def mods_classes(base_class, mods)
				mods.map do |key, value|
					next('') unless value
					mod = mod_class(key, value)
					base_class + RailsBlocks.config.modifier_separator + mod
				end
			end
			
			def mod_class(key, value)
				value == true ? key.to_s : key.to_s + '_' + value.to_s
			end
			
			def block_class(b_name)
				RailsBlocks.config.prefix + b_name.to_s
			end
			
			def element_class(b_name, e_name)
				block_class(b_name) + RailsBlocks.config.element_separator + e_name.to_s
			end
	end
end