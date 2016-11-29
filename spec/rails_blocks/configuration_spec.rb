describe RailsBlocks::Configuration do
	subject { RailsBlocks::Configuration.new }

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