module ActiveRecord
  module Acts #:nodoc:
    module MuckProfile #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_profile(options = {})

          belongs_to :user
          belongs_to :state
          belongs_to :country
          belongs_to :language
          
          acts_as_mappable
          
          has_attached_file :photo, 
                            :styles => { :medium => "300x300>",
                                         :thumb => "100x100>",
                                         :icon => "50x50>",
                                         :tiny => "24x24>" },
                            :default_url => "/images/profile_default.jpg"

          before_save :sanitize_attributes

          class_eval <<-EOV
            attr_protected :created_at, :updated_at, :photo_file_name, :photo_content_type, :photo_file_size
          EOV

          include ActiveRecord::Acts::MuckProfile::InstanceMethods
          extend ActiveRecord::Acts::MuckProfile::SingletonMethods

        end
      end

      # class methods
      module SingletonMethods

      end

      # All the methods available to a record that has had <tt>acts_as_muck_profile</tt> specified.
      module InstanceMethods
        
        def can_edit?(user)
          return false if user.nil?
          self.user_id == user.id || user.admin?
        end
        
        def guess_and_assign_location_via_ip
          if GlobalConfig.enable_guess_location && self.user.current_login_ip
            location = Geokit::Geocoders::MultiGeocoder.geocode(self.user.current_login_ip)
            state = State.find_by_abbreviation(location.state)
            country = Country.find_by_abbreviation(location.country)
            self.update_attributes(
              :location => "#{location.city}, #{location.state || location.province} #{location.country_code}",
              :lat => location.lat,
              :lng => location.lng,
              :city => location.city,
              :state => state,
              :country => country)
          end
        end
        
        def after_create
          guess_and_assign_location_via_ip
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
end
