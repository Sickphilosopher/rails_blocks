require 'rails_blocks/levels'
module RailsBlocks
	class Engine < Rails::Engine
		isolate_namespace RailsBlocks
		initializer 'rails_blocks.configure_rails_initialization' do
			require 'rails_blocks/initializers/rails_blocks'
		end
		
		initializer 'rails_blocks.precompile', :group => :all do |app|
			app.config.assets.precompile += %w( rails_blocks.js )
		end
		
		include RailsBlocks::Levels
		config.to_prepare do
			RailsBlocks::Levels.get_levels
			ApplicationController.helper(BlockHelper)
		end
	end
end