require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::ProfilesController do

  render_views
  
  describe "index" do
    before(:each) do
      get :index
    end
    it { should respond_with :success }
    it { should render_template :index }
  end
  
  # describe "search" do
  #   before(:each) do
  #     @user = Factory(:user)
  #     get :search, :q => 'bill'
  #   end
  #   it { should respond_with :success }
  #   it { should render_template :search }
  # end
  
  describe "GET show" do
    before(:each) do
      @user = Factory(:user)
      get :show, :id => @user.to_param
    end
    it { should respond_with :success }
    it { should render_template :show }
  end

  describe "GET edit" do
    before(:each) do
      @user = Factory(:user)
      get :edit, :user_id => @user.to_param
    end
    it { should respond_with :success }
    it { should render_template :edit }
  end
  
  describe "update" do
    before(:each) do
      @user = Factory(:user)
      put :update, :user_id => @user.id, :user => { :profile_attributes => { :about => 'test'} }
    end
    it { should set_the_flash.to(I18n.translate('muck.profiles.edit_success')) }
  end
  
end
