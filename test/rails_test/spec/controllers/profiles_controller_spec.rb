require File.dirname(__FILE__) + '/../spec_helper'

describe Muck::ProfilesController do

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
  
end
