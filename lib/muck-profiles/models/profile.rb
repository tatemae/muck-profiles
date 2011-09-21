# include MuckProfiles::Models::MuckProfile
require 'paperclip'
require 'sanitize'

module MuckProfiles
  module Models
    module MuckProfile

      extend ActiveSupport::Concern
      
      included do
        include MuckEngine::RemotePhotoMethods
        belongs_to :user
        belongs_to :state
        belongs_to :country
        belongs_to :language
        
        has_attached_file :photo, 
                          :styles => { :medium => "300x300>",
                                       :thumb => "100x100>",
                                       :icon => "50x50>",
                                       :tiny => "24x24>" },
                          :default_url => "/images/profile_default.jpg"

        before_save :sanitize_attributes

        delegate :email, :to => :user
        delegate :login, :to => :user
        delegate :first_name, :to => :user
        delegate :last_name, :to => :user
        delegate :display_name, :to => :user
        delegate :full_name, :to => :user

        acts_as_mappable if MuckProfiles.configuration.enable_geokit
        
        after_create :guess_and_assign_location_via_ip
        
        if MuckProfiles.configuration.enable_solr || MuckProfiles.configuration.enable_sunspot
          fields = []
          MuckProfiles.configuration.policy.keys.each do |key|
            field_name = "#{key}_fields"
            fields << {field_name.to_sym => :text}
            # Setup a method for each key in the policy that can generate a string of all the fields
            # associated with that key.  acts_as_solr or sunspot will call this method.
            instance_eval do
              define_method field_name do
                MuckProfiles.configuration.policy[key].collect{ |attribute| self.send(attribute) }.join(' ')
              end
            end
          end
          write_inheritable_array(:solr_fields, fields)
          write_inheritable_hash(:default_policy, MuckProfiles.configuration.policy)

          if MuckProfiles.configuration.enable_solr
            require 'acts_as_solr'
            acts_as_solr( {:fields => fields}, {:multi_core => true, :default_core => 'en'})
          elsif MuckProfiles.configuration.enable_sunspot
            require 'sunspot'
            searchable do
              fields.each do |field|
                text field
              end
            end
          end
        end

        attr_protected :created_at, :updated_at, :photo_file_name, :photo_content_type, :photo_file_size
          
      end

      def can_edit?(user)
        return false if user.nil?
        self.user_id == user.id || user.admin?
      end
      
      def guess_and_assign_location_via_ip
        if MuckProfiles.configuration.enable_guess_location && self.user.current_login_ip
          location = Geokit::Geocoders::MultiGeocoder.geocode(self.user.current_login_ip)
          state = State.find_by_abbreviation(location.state)
          country = Country.find_by_abbreviation(location.country_code)
          self.update_attributes(
            :location => "#{location.city}, #{location.state || location.province} #{location.country_code}",
            :lat => location.lat,
            :lng => location.lng,
            :city => location.city,
            :state => state,
            :country => country)
        end
      end
      
      # Sanitize content before saving.  This prevent XSS attacks and other malicious html.
      def sanitize_attributes
        if self.sanitize_level
          self.about = Sanitize.clean(self.about, self.sanitize_level) unless self.about.blank?
          self.location = Sanitize.clean(self.location, self.sanitize_level) unless self.location.blank?
        end
      end
      
      # Override this method to control sanitization levels.
      # Currently a user who is an admin will not have their content sanitized.  A user
      # in any role 'editor', 'manager', or 'contributor' will be given the 'RELAXED' settings
      # while all other users will get 'BASIC'.
      #
      # Options are from sanitze:
      # nil - no sanitize
      # Sanitize::Config::RELAXED
      # Sanitize::Config::BASIC
      # Sanitize::Config::RESTRICTED
      # for more details see: http://rgrove.github.com/sanitize/
      def sanitize_level
        return Sanitize::Config::BASIC if self.user.nil?
        return nil if self.user.admin?
        return Sanitize::Config::RELAXED if self.user.any_role?('editor', 'manager', 'contributor')
        Sanitize::Config::BASIC
      end

    end
  end
end
