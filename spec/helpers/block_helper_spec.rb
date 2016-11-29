describe BlockHelper, type: :helper do
	before do
		controller.add_view_paths
	end

	context ".b" do
		it "renders empty div with class when called without options" do
			result = b :test
			expect(result).to eq '<div class="test"></div>'
		end
		
		it "renders div with content when called with block" do
			result = b 'test-block' do
				'test-content'
			end
			expect(result).to eq '<div class="test-block">test-content</div>'
		end
		
		it "renders empty div with mods class when called with mods" do
			result = b 'test-block', mods: {test: :one}
			expect(result).to eq '<div class="test-block test-block--test_one"></div>'
		end
		
		it 'renders file when one exists' do
			result = b 'block1'
			expect(result).to eq '<div class="block1">block1</div>'
		end

		it 'ads js-bem class and data-bem when js: true' do
			result = b 'b1', js: true
			expect(result).to eq '<div class="b1 js-bem" data-bem="{&quot;b1&quot;:{}}"></div>'
		end

		it 'ads js-bem class and mixed data-bem when js: true in mix' do
			result = b 'b1', mix: {b: 'b2', js: true}
			expect(result).to eq '<div class="b1 b2 js-bem" data-bem="{&quot;b2&quot;:{}}"></div>'
		end

		it 'ads js-bem class and full data-bem when js: true in mix' do
			result = b 'b1', js: true, mix: {b: 'b2', js: true}
			expect(result).to eq '<div class="b1 b2 js-bem" data-bem="{&quot;b1&quot;:{},&quot;b2&quot;:{}}"></div>'
		end

		it 'ads js-bem class and full custom data-bem when js: true in mix' do
			result = b 'b1', js: {bb1: 'boo'}, mix: {b: 'b2', js: {bb2: 'boo2'}}
			expect(result).to eq '<div class="b1 b2 js-bem" data-bem="{&quot;b1&quot;:{&quot;bb1&quot;:&quot;boo&quot;},&quot;b2&quot;:{&quot;bb2&quot;:&quot;boo2&quot;}}"></div>'
		end
	end
	
	context ".e" do
		it "raise error when called outside block" do
			expect{ e 'test-element' }.to raise_error RailsBlocks::NoBlockContextError
		end
		
		it "renders empty element with class when called without options" do
			b 'test' do
				result = e :element
				expect(result).to eq '<div class="test__element"></div>'
			end
		end
		
		it "renders element with mods class when called with mods" do
			b 'test' do
				result = e 'element', mods: {test: :boo, test2: true}
				expect(result).to eq '<div class="test__element test__element--test_boo test__element--test2"></div>'
			end
		end
		
		it "renders element with class & content when called with block" do
			b 'test' do
				result = e 'element' do
					"content"
				end
				expect(result).to eq '<div class="test__element">content</div>'
			end
		end

		it 'ads data-bem, but not js-bem class when js: true' do
			b 'test' do
				result = e 'e1', js: {test: 2}
				expect(result).to eq '<div class="test__e1" data-bem="{&quot;test__e1&quot;:{&quot;test&quot;:2}}"></div>'
			end
		end

		it 'ads js-bem class and mixed data-bem when js: true in mix with block' do
			b 'test' do
				result = e 'e1', mix: {b: 'b1', js: true}
				expect(result).to eq '<div class="test__e1 b1 js-bem" data-bem="{&quot;b1&quot;:{}}"></div>'
			end
		end

		it 'ads js-bem class and full data-bem when js: true in mix' do
			result = b 'b1', js: true, mix: {b: 'b2', js: true}
			expect(result).to eq '<div class="b1 b2 js-bem" data-bem="{&quot;b1&quot;:{},&quot;b2&quot;:{}}"></div>'
		end
	end
end