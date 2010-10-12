class ApplicationController < ActionController::Base
  
  helper :all
  protect_from_forgery
  layout 'default'

  protected

    # **********************************************
    # SSL method
    # only require ssl if we are in production
    def ssl_required?
      return false
    end
    
    # called by Admin::Muck::BaseController to check whether or not the
    # user should have access to the admin UI
    def admin_access_required
      access_denied unless admin?
    end
    
end
