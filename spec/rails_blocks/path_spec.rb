describe RailsBlocks::Path do
	include RailsBlocks::Path
	let(:options) { {levels: %w(level1 level2)} }
	
	context '.block_template' do
		it 'returns nil if block dir not found' do
			template = block_template 'test-block', options
			expect(template).to be_nil
		end
		
		
		context 'when template exists' do
			it 'returns path when template exists' do
				template = block_template 'simple-block-with-template'
				expect(template).to eq Rails.root.join('app', 'blocks', 'test', 'simple-block-with-template', 'simple-block-with-template.slim').to_s
			end
			
			context 'when modified template exists' do
				it 'returns path of modified template' do
					template = block_template 'modified-block-with-template', mods: {test: :one}
					expect(template).to eq Rails.root.join('app', 'blocks', 'test', 'modified-block-with-template', 'modified-block-with-template_test_one.slim').to_s
				end
			end
			
			context 'when modified template not exists' do
				it 'returns path of original template' do
					template = block_template 'simple-block-with-template', mods: {test: :one}
					expect(template).to eq Rails.root.join('app', 'blocks', 'test', 'simple-block-with-template', 'simple-block-with-template.slim').to_s
				end
			end
		end
	end
	
	context '.element_template' do |variable|
		it 'returns nil if block dir not found' do
			template = element_template 'test', 'test'
			expect(template).to be_nil
		end
		
		it 'returns nil if block dir found but template not' do
			template = element_template 'elements-test', 'no-test'
			expect(template).to be_nil
		end
		
		context 'when template exists' do
			it 'returns path when element template exists' do
				template = element_template 'elements-test', 'element2'
				expect(template).to eq Rails.root.join('app', 'blocks', 'test', 'elements-test', '__element2.slim').to_s
			end
			
			context 'when modified template exists' do
				it 'returns path of modified template' do
					template = element_template 'elements-test', 'element2', mods: {type: :one}
					expect(template).to eq Rails.root.join('app', 'blocks', 'test', 'elements-test', '__element2_type_one.slim').to_s
				end
			end
			
			context 'when modified template not exists' do
				it 'returns path of original template' do
					template = element_template 'elements-test', 'element', mods: {type: :one}
					expect(template).to eq Rails.root.join('app', 'blocks', 'test', 'elements-test', '__element.slim').to_s
				end
			end
		end
	end
end