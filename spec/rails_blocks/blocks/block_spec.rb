require 'rails_blocks/blocks/block'

describe RailsBlocks::Blocks::Block do
	it 'render empty div with block class if block isn\'t defined' do
		b_name = 'test-block'
		block = RailsBlocks.get_block b_name
		result = block.render
		klass = RailsBlocks.config.prefix + b_name
		expect(result).to match(/<div.*\/div>/) & match(/class=\"#{klass}\"/)
	end
end