require 'muck_profiles'
require 'rails'

module MuckProfiles
  class Engine < ::Rails::Engine
    
    def muck_name
      'muck-profiles'
    end
    
    initializer 'muck_profiles.helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include MuckProfilesHelper
      end
    end
    
    initializer 'muck_profiles.i18n' do |app|
      ActiveSupport.on_load(:i18n) do
        I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', '..', 'config', 'locales', '*.{rb,yml}') ]
      end
    end
        
  end
end
