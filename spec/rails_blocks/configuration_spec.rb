describe RailsBlocks::Configuration do
	describe "#prefix" do
		it "default value is 'b-'" do
			expect(RailsBlocks::Configuration.new.prefix).to eq 'b-'
		end
	end

	describe "#prefix=" do
		it "can set value" do
			config = RailsBlocks::Configuration.new
			config.prefix = 't-'
			expect(config.prefix).to eq 't-'
		end
	end
end