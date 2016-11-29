require 'rails_blocks'
require 'rails'

describe RailsBlocks do
	describe ".configure" do

		it "set path for blocks folder" do
			RailsBlocks.configure do |config|
				config.blocks_dir = 'bem'
			end
			
			expect(RailsBlocks.config.blocks_dir).to eq 'bem'
		end
		
		it "set levels for bem" do
			RailsBlocks.configure do |config|
				config.levels = ['common', 'test']
			end
			
			expect(RailsBlocks.config.levels).to eq %w(common test)
		end
		
		it "set template_engine for bem" do
			RailsBlocks.configure do |config|
				config.template_engine = '.haml'
			end
			
			expect(RailsBlocks.config.template_engine).to eq '.haml'
		end
		
		it "set element_separator for bem" do
			RailsBlocks.configure do |config|
				config.element_separator = 'sepa'
			end
			
			expect(RailsBlocks.config.element_separator).to eq 'sepa'
		end
		
		it "set modifier_separator for bem" do
			RailsBlocks.configure do |config|
				config.modifier_separator = 'sepa'
			end
			
			expect(RailsBlocks.config.modifier_separator).to eq 'sepa'
		end
		
		it "set modifier_separator for bem" do
			RailsBlocks.configure do |config|
				config.modifier_separator = 'sepa'
			end
			
			expect(RailsBlocks.config.modifier_separator).to eq 'sepa'
		end
	end
	
	describe ".reset" do
		before :each do
			RailsBlocks.configure do |config|
				config.blocks_dir = 'test_path'
				config.levels = ['common', 'test']
				config.template_engine = '.haml'
				config.element_separator = 'sepa'
			end
		end

		it "resets the configuration block_path" do
			RailsBlocks.reset
			expect(RailsBlocks.config.blocks_dir).to eq('app/blocks')
		end
		
		it "resets the configuration levels" do
			RailsBlocks.reset
			expect(RailsBlocks.config.levels.length).to be 0
		end
		
		it "resets the configuration template_engine" do
			RailsBlocks.reset
			expect(RailsBlocks.config.template_engine).to eq '.slim'
		end
		
		it "resets the configuration element_separator" do
			RailsBlocks.reset
			expect(RailsBlocks.config.element_separator).to eq '__'
		end
		
		it "resets the configuration modifier_separator" do
			RailsBlocks.reset
			expect(RailsBlocks.config.modifier_separator).to eq '--'
		end
	end
end