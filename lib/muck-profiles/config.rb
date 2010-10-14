require 'ostruct'

module MuckProfiles
  
  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    
    attr_accessor :enable_solr            # This enables or disables acts as solr for profiles.
    attr_accessor :enable_geokit          # Turn geokit functionality on/off
    attr_accessor :enable_guess_location  # If true the profile system will attempt to determine the user's location via IP and populated with the location, lat and lon fields.
    attr_accessor :policy
    
    def initialize
      self.enable_solr = true
      self.enable_guess_location = true
      self.policy = { :public => [:login, :first_name, :last_name, :about],
                     :authenticated => [:location, :city, :state_id, :country_id, :language_id],
                     :friends => [:email],
                     :private => [] }
    end
    
  end
end