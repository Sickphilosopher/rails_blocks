require 'rails_blocks/names'

describe RailsBlocks::Names do
	include RailsBlocks::Names
	context '.element_classes' do
		it 'returns simple element_classes without options' do
			classes = element_classes 'block', 'element'
			expect(classes).to contain_exactly 'b-block__element'
		end
		
		it 'returns element_class & mods with options[:mods]' do
			classes = element_classes 'block', 'element', mods: {test: :one}
			expect(classes).to contain_exactly 'b-block__element', 'b-block__element--test_one'
		end
	end
	
	context '.block_classes' do
		it 'returns simple block_class without options' do
			classes = block_classes 'block'
			expect(classes).to contain_exactly 'b-block'
		end
		
		it 'returns block_class & mods with options[:mods]' do
			classes = block_classes 'block', mods: {test: :one}
			expect(classes).to contain_exactly 'b-block', 'b-block--test_one'
		end
	end
	
	context '.mods_classes' do
		it 'returns mods classes' do
			classes = mods_classes 'b-base', {test: :one, boo: :two}
			expect(classes).to contain_exactly 'b-base--test_one', 'b-base--boo_two'
		end
	end
	
	context '.mix_classes' do
		it 'returns element class when one :b & :e exists' do
			classes = mix_classes b: :block, e: :element
			expect(classes).to contain_exactly 'b-block__element'
		end
		
		it 'returns element classes when array :b & :e exists' do
			classes = mix_classes [{b: :block, e: :element}, {b: 'block2', e: 'element2'}]
			expect(classes).to contain_exactly 'b-block__element', 'b-block2__element2'
		end
		
		it 'returns blocks classes when only :b exists' do
			classes = mix_classes b: :block
			expect(classes).to contain_exactly 'b-block'
		end
		
		it 'returns blocks classes when array of :b exists' do
			classes = mix_classes [{b: :block}, {b: :test}]
			expect(classes).to contain_exactly 'b-block', 'b-test'
		end
		
		it 'returns blocks classes & element classes when array of :b, :b & :e exists' do
			classes = mix_classes [{b: :block}, {b: :test, e: :boo}]
			expect(classes).to contain_exactly 'b-block', 'b-test__boo'
		end
		
		it 'raise error if :b not exists' do
			expect { mix_classes(e: :boo) }.to raise_error RailsBlocks::BadMixError
		end
	end
end