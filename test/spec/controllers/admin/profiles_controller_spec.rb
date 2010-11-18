require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::Muck::ProfilesController do

  render_views
  
  it { should require_login :edit, :get }
  
  describe "logged in as normal user" do
    before(:each) do
      @user = Factory(:user)
      activate_authlogic
      login_as @user
    end
    it { should require_role 'admin', :edit, :get }
  end

  describe "logged in as admin" do

    before(:each) do
      @admin = Factory(:user)
      @admin_role = Factory(:role, :rolename => 'administrator')
      @admin.roles << @admin_role
      activate_authlogic
      login_as @admin
    end

    describe "GET edit" do
      before(:each) do
        get :edit
      end
      it { should respond_with :success }
      it { should render_template :edit }
    end

  end

end
