# == Schema Information
#
# Table name: users
#
#  id                  :integer(4)      not null, primary key
#  login               :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  crypted_password    :string(255)
#  password_salt       :string(255)
#  persistence_token   :string(255)
#  single_access_token :string(255)
#  perishable_token    :string(255)
#  login_count         :integer(4)      default(0), not null
#  failed_login_count  :integer(4)      default(0), not null
#  last_request_at     :datetime
#  last_login_at       :datetime
#  current_login_at    :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  terms_of_service    :boolean(1)      not null
#  time_zone           :string(255)     default("UTC")
#  disabled_at         :datetime
#  activated_at        :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  context 'A user instance with has_muck_profile' do
    setup do
      @user = Factory(:user)
    end
    subject { @user }
    
    should_accept_nested_attributes_for :profile
    should_have_one :profile
    
    should "have a profile after creation" do
      assert @user.profile
    end

    should "have a photo method delegated to the profile" do
      assert @user.photo
    end
  end

end
