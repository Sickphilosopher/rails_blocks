require 'rails_blocks/helpers/block_helper'

describe BlockHelper, type: :helper do
	it "returns block content when simple b called" do
		result = b 'test-block'
		block = RailsBlocks.get_block 'test-block'
		expect(result).to eq(block.render)
	end
end