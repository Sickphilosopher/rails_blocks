require 'rails_blocks/names'
module RailsBlocks
	module Path
		include RailsBlocks::Names
		ELEMENT_FILE_PREFIX = '__'
		MOD_FILE_PREFIX = '_'
		
		class << self
			attr_writer :tree
		end

		def self.tree
			#so slow, переделать на оновление при запросе, а не каждый раз
			#return build_tree if Rails.env.development?
			@tree ||= (
				build_tree
			)
		end
		
		def self.blocks_dir
			Rails.root.join RailsBlocks.config.blocks_dir
		end
		
		def block_template(b_name, options = {})
			options[:levels].reverse.each do |level|
				next unless Path.tree[level][b_name]
				return Path.tree[level][b_name][mod(options)] || Path.tree[level][b_name]['']
			end
			nil
		end
		
		def element_template(b_name, e_name, options = {})
			options[:levels].reverse.each do |level|
				next unless Path.tree[level][b_name]
				next unless Path.tree[level][b_name][:elements][e_name]
				return Path.tree[level][b_name][:elements][e_name][mod(options)] || Path.tree[level][b_name][:elements][e_name]['']
			end
			nil
		end
		
		private
			
			def mod(options)
				return '' unless options[:mods] && !options[:mods].empty?
				mod_class(*options[:mods].first)
			end
			
			def get_block_dir(b_name, levels)
				levels.reverse.each do |level|
					block_dir = File.join(self.blocks_dir, level, b_name)
					if Dir.exists? block_dir
						return block_dir
					end
				end
				nil
			end
			
			def self.build_tree
				file_tree
			end
			
			def self.file_tree
				t = {}
				files = Dir["#{blocks_dir}/**/*#{RailsBlocks.config.template_engine}"]
				files.each do |file|
					file.sub! blocks_dir.to_s + '/', ''
					parts = file.split('/')
					filename = parts[2].sub RailsBlocks.config.template_engine, ''
					template = {
						level: parts[0],
						block: parts[1],
						file: filename
					}
					t[template[:level]] ||= {}
					t[template[:level]][template[:block]] ||= {elements: {}}
					
					if is_e_file(filename)
						t[template[:level]][template[:block]][:elements][get_e_name(filename)] ||= {}
						t[template[:level]][template[:block]][:elements][get_e_name(filename)][get_e_mod(filename)] = file
					else
						t[template[:level]][template[:block]][get_b_mod(filename)] = file
					end
				end
				t.with_indifferent_access.freeze
			end
			
			def self.is_e_file(file)
				file.start_with? ELEMENT_FILE_PREFIX
			end
			
			def self.get_e_name(file)
				file.match(/\A__([^_]*)/)
				$1
			end
			
			def self.get_e_mod(file)
				return '' unless file.match(/__\w+#{MOD_FILE_PREFIX}\w/)
				file.match(/\A__(?:[^_]*)_(.*)/)
				$1
			end
			
			def self.get_b_mod(file)
				return '' unless file.start_with? MOD_FILE_PREFIX
				file.match(/^_(.*)/)
				$1
			end
	end
end