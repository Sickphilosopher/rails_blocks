RailsBlocks.configure do |config|
	config.levels = [:common, :app]
	
	config.ns :admin do |ns_config|
		ns_config.levels = [:common, :admin]
	end
end