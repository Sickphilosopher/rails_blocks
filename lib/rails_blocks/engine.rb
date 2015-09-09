require 'rails_blocks/levels'
module RailsBlocks
	class Engine < Rails::Engine
		#isolate_namespace RailsBlocks
		config.autoload_paths << File.expand_path("../rails_blocks", __FILE__)
		
		initializer 'rails_blocks.configure_rails_initialization' do
			require 'rails_blocks/initializers/rails_blocks'
		end
		
		initializer 'rails_blocks.precompile', :group => :all do |app|
			app.config.assets.precompile += %w( rails_blocks.js )
		end
		
		config.to_prepare do
			ApplicationController.helper(BlockHelper)
		end
		
		ActiveSupport.on_load :action_controller do
			include RailsBlocks::Levels
			before_filter :add_view_paths
		end
		
		rake_tasks do
			load "tasks/rails_blocks.rake"
		end
	end
end