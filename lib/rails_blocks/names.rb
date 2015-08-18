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
		
		def mix_classes(mixes, context_block)
			Array(mixes).map do |mix|
				if mix[:e].nil?
					raise RailsBlocks::BadMixError if mix[:b].nil?
					block_class(mix[:b].to_s)
				else
					raise RailsBlocks::BadMixError if context_block.nil?
					element_class(context_block, mix[:e].to_s)
				end
			end
		end
		
		private
			def classes(base_class, options = {})
				classes = [base_class]
				classes |= mods_classes(base_class, options[:mods]) unless options[:mods].nil?
				classes
			end
			
			def mods_classes(base_class, mods)
				mods.map do |key, value|
					mod = value == :true ? key.to_s : key.to_s + '_' + value.to_s
					base_class + RailsBlocks.config.modifier_separator + mod
				end
			end
			
			def block_class(b_name)
				RailsBlocks.config.prefix + b_name.to_s
			end
			
			def element_class(b_name, e_name)
				block_class(b_name) + RailsBlocks.config.element_separator + e_name.to_s
			end
	end
end