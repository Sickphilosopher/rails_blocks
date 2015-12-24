describe BlockHelper, type: :helper do
	include BlockHelper
	context ".b" do
		it "renders empty div with class when called without options" do
			result = b :test
			expect(result).to eq '<div class=\'b-test\'></div>'
		end
		
		it "renders div with content when called with block" do
			result = b 'test-block' do
				'test-content'
			end
			expect(result).to eq '<div class=\'b-test-block\'>test-content</div>'
		end
		
		it "renders empty div with mods class when called with mods" do
			result = b 'test-block', mods: {test: :one}
			expect(result).to eq '<div class=\'b-test-block b-test-block--test_one\'></div>'
		end
	end
	
	context ".e" do
		it "raise error when called outside block" do
			expect{ e 'test-element' }.to raise_error RailsBlocks::NoBlockContextError
		end
		
		it "renders empty element with class when called without options" do
			b 'test' do
				result = e :element
				expect(result).to eq '<div class=\'b-test__element\'></div>'
			end
		end
		
		it "renders element with mods class when called with mods" do
			b 'test' do
				result = e 'element', mods: {test: :boo, test2: true}
				expect(result).to eq '<div class=\'b-test__element b-test__element--test_boo b-test__element--test2\'></div>'
			end
		end
		
		it "renders element with class & content when called with block" do
			b 'test' do
				result = e 'element' do
					"content"
				end
				expect(result).to eq '<div class=\'b-test__element\'>content</div>'
			end
		end
	end
end