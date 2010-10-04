module MuckProfiles
  module Models
    module User

      extend ActiveSupport::Concern
      
      included do
          
        has_one :profile, :dependent => :destroy
        accepts_nested_attributes_for :profile, :allow_destroy => true
        after_create {|user| user.create_profile unless user.profile}
        delegate :photo, :to => :profile
           
      end

    end
  end
end
