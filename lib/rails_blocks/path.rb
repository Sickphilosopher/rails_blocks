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
			@tree ||= (
				build_tree
			)
		end

		def self.reload_tree
			@tree = build_tree
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

		def block_js_level(b_name, levels)
			return levels.reverse.find do |level|
				Path.tree.dig(level, b_name, :js)
			end
		end

		def block_js_ext(b_name, level)
			return Path.tree.dig(level, b_name, :js_ext)
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
				engine_ext = RailsBlocks.config.template_engine
				files = Dir["#{blocks_dir}/**/*#{engine_ext}"]
				files.each do |file|
					file.sub! blocks_dir.to_s + '/', ''
					file.sub! '.html' + engine_ext, ''
					
					parts = file.split('/')
					filename = File.basename(file, engine_ext)
					filename = File.basename(filename, '.html')
					# p filename
					level, block = parts
					t[level] ||= {}
					block_def = (t[level][block] ||= {elements: {}})
					
					if is_e_file(filename)
						block_def[:elements][get_e_name(filename)] ||= {}
						block_def[:elements][get_e_name(filename)][get_e_mod(filename)] = file
					else
						block_def[get_b_mod(filename)] = file
					end
				end
				add_js(t)
				t.with_indifferent_access.freeze
			end

			def self.add_js(t)
				exts = RailsBlocks.config.js_exts.join(',')
				js_files = Dir["#{blocks_dir}/**/*.{#{exts}}"]
				js_files.each do |file|
					file.sub! blocks_dir.to_s + '/', ''
					parts = file.split('/')
					level, block, filename = parts
					ext = File.extname(filename)
					filename = File.basename(filename, '.*')

					t[level] ||= {}
					block_def = t[level][block] ||= {elements: {}}
					block_def[:js] = true
					block_def[:js_ext] = ext[1..-1]
				end
				p t
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