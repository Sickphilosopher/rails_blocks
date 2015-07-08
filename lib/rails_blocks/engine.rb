require 'rails_blocks/helpers/block_helper'

module RailsBlocks
	class Engine < Rails::Engine
		initializer 'rails_blocks.configure_rails_initialization' do
			require 'rails_blocks/initializers/rails_blocks'
		end
		
		initializer 'rails_blocks.precompile', :group => :all do |app|
			app.config.assets.precompile += %w( rails_blocks.js )
		end
		
		ActiveSupport.on_load :action_view do
			include RailsBlocks::Helpers::BlockHelper
		end
	end
end