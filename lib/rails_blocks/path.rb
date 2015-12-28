module RailsBlocks
	module Path
		class << self
			attr_writer :tree
		end

		def self.tree
			return build_tree unless Rails.env.production?
			@tree ||= (
				build_tree
			)
		end
		
		def self.blocks_dir
			Rails.root.join RailsBlocks.config.blocks_dir
		end
		
		def block_template(b_name, options = {})
			options[:levels].reverse.each do |level|
				p level
				p b_name
				p Path.tree
				p 'test'
				next unless Path.tree[level][b_name]
				return Path.tree[level][b_name][mod(options)] if Path.tree[level][b_name][mod(options)]
				return Path.tree[level][b_name]['']
			end
			nil
		end
		
		def element_template(b_name, e_name, options = {})
			options[:levels].reverse.each do |level|
				next unless Path.tree[level][b_name]
				return Path.tree[level][b_name]["_#{e_name}"] if Path.tree[level][b_name]["_#{e_name}"]
			end
			nil
		end
		
		private
			
			def mod(options)
				return '' unless options[:mods] && !options[:mods].empty?
				mod_class(*options[:mods].first)
			end
			
			def mod_path(dir, name, options)
				return nil unless options[:mods]
				path = File.join dir, name + '_' + mod_class(*options[:mods].first) + RailsBlocks.config.template_engine
				File.exists?(path) ? path : nil
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
				t = {}
				files = Dir["#{blocks_dir}/**/*#{RailsBlocks.config.template_engine}"]
				files.each do |file|
					file.sub! blocks_dir.to_s + '/', ''
					parts = file.split('/')
					template = {
						level: parts[0],
						block: parts[1],
						file: parts[2].gsub('.slim', '')
					}
					t[template[:level]] ||= {}
					t[template[:level]][template[:block]] ||= {}
					t[template[:level]][template[:block]][get_mod(file)] = file
				end
				t.freeze
			end
			
			def self.get_mod(file)
				return '' unless file.include? '_'
				file.match(/_(.*)\./)
				$1
			end
	end
end