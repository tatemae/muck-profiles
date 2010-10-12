require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  describe 'A user instance with include MuckProfiles::Models::MuckUser' do
    before(:each) do
      @user = Factory(:user)
    end
    
    it { should accept_nested_attributes_for :profile }
    it { should have_one :profile }
    
    it "adds a profile after the user is created" do
      @user.profile.should_not be_nil
    end

    it "adds a photo method to the user delegated to the profile" do
      @user.photo.should_not be_nil
    end
  end

end
