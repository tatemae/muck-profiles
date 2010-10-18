require File.dirname(__FILE__) + '/../spec_helper'

describe Profile do

  before(:each) do
    @login = 'testguy'
    @first_name = 'test'
    @last_name = 'guy'
    @email = 'test@example.com'
    @user = Factory(:user, :login => @login, :first_name => @first_name, :last_name => @last_name, :email => @email)
    @profile = @user.profile
  end
  
  it { should belong_to :user }
  it { should belong_to :state }
  it { should belong_to :country }
  it { should belong_to :language }

  it "should delegate email to user" do
    @email.should == @profile.email
  end
  
  it "should delegate login to user" do
    @login.should == @profile.login
  end
  
  it "should delegate first_name to user" do
    @first_name.should == @profile.first_name
  end
  
  it "should delegate last_name to user" do
    @last_name.should == @profile.last_name
  end

  describe "sanitize" do
    before do
      @profile = Factory(:profile)
    end
    it "should sanitize user input fields" do
      @profile.should sanitize(:about)
      @profile.should sanitize(:location)
    end
  end
  
  describe "methods for acts_as_solr" do
    
    it "should have public_fields" do
      get_fields_string(@profile, [:login, :first_name, :last_name, :about]).should == @profile.public_fields
    end
    
    it "should have authenticated_fields" do
      get_fields_string(@profile, [:location, :city, :state_id, :country_id, :language_id]).should == @profile.authenticated_fields
    end
    
    it "should have friends_fields" do
      get_fields_string(@profile, [:email]).should == @profile.friends_fields
    end
       
    it "should have private_fields" do
      get_fields_string(@profile, []).should == @profile.private_fields
    end

    it "should raise an exception if the field doesn't exist" do
      
    end
    
  end

  describe "guess_and_assign_location_via_ip" do
    before(:each) do
      @user = Factory(:user, :current_login_ip => '129.123.54.100')
      @profile = @user.profile
      @state = Factory(:state, :abbreviation => 'UT')
      @country = Factory(:country, :abbreviation => 'US')
    end
    it "should find a location for the given IP" do
      @profile.guess_and_assign_location_via_ip
      @profile.location.should include('Logan')
      @profile.lat.should_not be_blank
      @profile.lng.should_not be_blank
      @profile.city.should_not be_blank
      @profile.state.should == @state
      @profile.country.should == @country
    end
  end
  
  def get_fields_string(profile, fields)
    fields.collect{ |f| profile.send(f) }.join(' ')
  end
  
end


