describe RailsBlocks::Path do
	include RailsBlocks::Path
	let(:options) { {levels: [:common, :app]} }
	
	context '.block_template' do
		it 'returns nil if block dir not found' do
			template = block_template 'test-block', options
			expect(template).to be_nil
		end
		
		context 'when template exists' do
			it 'returns path when template exists' do
				template = block_template 'block1', options
				expect(template).to eq "common/block1/block1#{RailsBlocks.config.template_engine}"
			end
			
			context 'when modified template exists' do
				it 'returns path of template with simple mod' do
					template = block_template 'block1', options.merge(mods: {mod1: true})
					expect(template).to eq "common/block1/_mod1#{RailsBlocks.config.template_engine}"
				end
				
				it 'returns path of template with key_value mod' do
					template = block_template 'block1', options.merge(mods: {mod2: 'value2'})
					expect(template).to eq "common/block1/_mod2_value2#{RailsBlocks.config.template_engine}"
				end
			end
			
			context 'when modified template not exists' do
				it 'returns path of original template' do
					template = block_template 'block1', options.merge(mods: {mod1: 'not-exists'})
					expect(template).to eq "common/block1/block1#{RailsBlocks.config.template_engine}"
				end
			end
		end
	end
	
	context '.element_template' do |variable|
		it 'returns nil if block dir not found' do
			template = element_template 'not-found', 'test', options
			expect(template).to be_nil
		end
		
		it 'returns nil if block dir found but template not' do
			template = element_template 'block1', 'not-exist-e', options
			expect(template).to be_nil
		end
		
		context 'when template exists' do
			it 'returns path when element template exists' do
				template = element_template 'block2', 'elem1', options
				expect(template).to eq "common/block2/__elem1#{RailsBlocks.config.template_engine}"
			end
			
			context 'when modified template exists' do
				it 'returns path of modified template' do
					template = element_template 'block2', 'elem1', options.merge(mods: {mod1: true})
					expect(template).to eq "common/block2/__elem1_mod1#{RailsBlocks.config.template_engine}"
				end
			end
			
			context 'when modified template not exists' do
				it 'returns path of original template' do
					template = element_template 'block2', 'elem1', options.merge(mods: {mod3: 'not-exist'})
					expect(template).to eq "common/block2/__elem1#{RailsBlocks.config.template_engine}"
				end
			end
		end
	end
end