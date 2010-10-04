# == Schema Information
#
# Table name: profiles
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#  location           :string(255)
#  lat                :decimal(15, 10)
#  lng                :decimal(15, 10)
#  about              :text
#  city               :string(255)
#  state_id           :integer(4)
#  country_id         :integer(4)
#  language_id        :integer(4)
#

class Profile < ActiveRecord::Base
  MuckProfiles::Models::Profile
end