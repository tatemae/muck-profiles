require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase

  context 'A profile' do
    setup do
      @user = Factory(:user)
      @profile = @user.profile
    end
    subject { @profile }
    
    should_belong_to :user
    
  end

end
