require File.join(File.dirname(__FILE__), '..', '..', 'app', 'helpers', 'block_helper')

describe BlockHelper, type: :helper do
	include BlockHelper
	it "returns empty div with classwhen simple b called" do
		result = b 'test-block'
		expect(result).to eq("<div class=\"b-test-block\"></div>")
	end
end