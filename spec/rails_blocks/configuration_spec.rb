describe RailsBlocks::Configuration do
	subject { RailsBlocks::Configuration.new }
	describe "#prefix" do
		it "default value is 'b-'" do
			expect(subject.prefix).to eq 'b-'
		end
	end

	describe "#prefix=" do
		it "can set value" do
			subject.prefix = 't-'
			expect(subject.prefix).to eq 't-'
		end
	end
	
	describe "#ns" do
		it 'yield new Configuration' do
			subject.ns :admin do |config|
				expect(config).to be_a RailsBlocks::Configuration
			end
		end
		
		xit 'creates new namespace' do
			subject.ns :admin do |config|
				expect(config.nss).not_to be_empty
			end
		end
	end
end