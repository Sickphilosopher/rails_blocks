require 'rails_blocks'

describe RailsBlocks do
	describe ".configure" do
		it "set prefix for block class" do
			RailsBlocks.configure do |config|
				config.prefix = 't-'
			end
			
			block = RailsBlocks.get_block 'test'
			expect(block.klass).to eq('t-test')
		end
		
		it "set path for blocks folder" do
			RailsBlocks.configure do |config|
				config.blocks_path = 'bem'
			end
			
			include RailsBlocks::Path
			root_path = Rails.root
			expect(blocks_path).to be(root_path + '/bem')
		end
		
		it "set levels for bem" do
			RailsBlocks.configure do |config|
				config.levels = ['common', 'test']
			end
			
			expect(RailsBlocks.config.levels).to be %w(common test)
		end
		
		it "set template_engine for bem" do
			RailsBlocks.configure do |config|
				config.template_engine = '.haml'
			end
			
			expect(RailsBlocks.config.template_engine).to be '.haml'
		end
		
		it "set element_separator for bem" do
			RailsBlocks.configure do |config|
				config.element_separator = 'sepa'
			end
			
			expect(RailsBlocks.config.element_separator).to be 'sepa'
		end
		
		it "set modifier_separator for bem" do
			RailsBlocks.configure do |config|
				config.modifier_separator = 'sepa'
			end
			
			expect(RailsBlocks.config.modifier_separator).to be 'sepa'
		end
	end
	
	describe ".reset" do
		before :each do
			RailsBlocks.configure do |config|
				config.prefix = 'test-'
				config.blocks_path = 'test_path'
				config.levels = ['common', 'test']
				config.template_engine = '.haml'
				config.element_separator = 'sepa'
			end
		end

		it "resets the configuration prefix" do
			RailsBlocks.reset
			expect(RailsBlocks.config.prefix).to eq('b-')
		end
		
		it "resets the configuration block_path" do
			RailsBlocks.reset
			expect(RailsBlocks.config.blocks_path).to eq('app/blocks')
		end
		
		it "resets the configuration levels" do
			RailsBlocks.reset
			expect(RailsBlocks.config.levels.length).to be 0
		end
		
		it "resets the configuration template_engine" do
			RailsBlocks.reset
			expect(RailsBlocks.config.template_engine).to be '.slim'
		end
		
		it "resets the configuration element_separator" do
			RailsBlocks.reset
			expect(RailsBlocks.config.element_separator).to be '__'
		end
		
		it "resets the configuration modifier_separator" do
			RailsBlocks.reset
			expect(RailsBlocks.config.modifier_separator).to be '--'
		end
	end
end