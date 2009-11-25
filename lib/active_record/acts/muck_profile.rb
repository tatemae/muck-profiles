module ActiveRecord
  module Acts #:nodoc:
    module MuckProfile #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def acts_as_muck_profile(options = {})

          belongs_to :user
          
          acts_as_mappable
          
          has_attached_file :photo, 
                            :styles => { :medium => "300x300>",
                                         :thumb => "100x100>",
                                         :icon => "50x50>",
                                         :tiny => "24x24>" },
                            :default_url => "/images/profile_default.jpg"


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
        
        def after_save
          debugger
          if GlobalConfig.enable_guess_location && self.user.current_login_ip
            location = Geokit::Geocoders::MultiGeocoder.geocode(self.user.current_login_ip)
            state = State.find_by_()
            country = Country.find_by  ()
            self.update_attributes(
              :location => "#{location.city}, #{location.state || location.province} #{location.country_code}",
              :lat => location.lat,
              :lng => location.lng,
              :city => location.city)
          end
        end
        
      end

    end
  end
end
