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
#  first_name         :string(255)
#  last_name          :string(255)
#  city               :string(255)
#  state_id           :integer(4)
#  country_id         :integer(4)
#  language_id        :integer(4)
#

require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase

  context "a profile" do
    
    setup do
      @login = 'testguy'
      @first_name = 'test'
      @last_name = 'guy'
      @email = 'test@example.com'
      @user = Factory(:user, :login => @login, :first_name => @first_name, :last_name => @last_name, :email => @email)
      @profile = @user.profile
    end
    
    subject { @profile }
    
    should_belong_to :user
    should_belong_to :state
    should_belong_to :country
    should_belong_to :language

    should "delegate email to user" do
      assert_equal @email, @profile.email
    end
    
    should "delegate login to user" do
      assert_equal @login, @profile.login
    end
    
    should "delegate first_name to user" do
      assert_equal @first_name, @profile.first_name
    end
    
    should "delegate last_name to user" do
      assert_equal @last_name, @profile.last_name
    end

    context "methods for acts_as_solr" do
      should "have public_fields" do
        assert_equal get_fields_string(@profile, [:login, :first_name, :last_name, :about]), @profile.public_fields
      end
      
      should "have authenticated_fields" do
        assert_equal get_fields_string(@profile, [:location, :city, :state_id, :country_id, :language_id]), @profile.authenticated_fields
      end
      
      should "have friends_fields" do
        assert_equal get_fields_string(@profile, [:email]), @profile.friends_fields
      end
         
      should "have private_fields" do
        assert_equal get_fields_string(@profile, []), @profile.private_fields
      end

      should "raise an exception if the field doesn't exist" do
        
      end
      
    end
    
  end

  def get_fields_string(profile, fields)
    fields.collect{ |f| profile.send(f) }.join(' ')
  end
end
