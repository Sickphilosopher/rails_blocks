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
	end
	
	describe ".reset" do
		before :each do
			RailsBlocks.configure do |config|
				config.prefix = 'test-'
			end
		end

		it "resets the configuration" do
			RailsBlocks.reset
			expect(RailsBlocks.config.prefix).to eq('b-')
		end
	end
end