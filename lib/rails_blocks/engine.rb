require 'rails_blocks/helpers/block_helper'

module RailsBlocks
	class Engine < Rails::Engine
		initializer "rails_blocks.configure_rails_initialization" do
			require 'rails_blocks/initializers/rails_blocks'
		end
		
		ActiveSupport.on_load :action_view do
			include RailsBlocks::Helpers::BlockHelper
		end
	end
end