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
	end
	
	describe ".reset" do
		before :each do
			RailsBlocks.configure do |config|
				config.prefix = 'test-'
				config.blocks_path = 'test_path'
				config.levels = ['common', 'test']
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
	end
end