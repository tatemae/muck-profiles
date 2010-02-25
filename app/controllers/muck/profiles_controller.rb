class Muck::ProfilesController < ApplicationController
  unloadable
  
  before_filter :setup_user, :only => [:show, :edit]
  
  def index
    @per_page = 400
    @users = User.by_newest.paginate(:page => @page, :per_page => @per_page, :include => 'profile')
    respond_to do |format|
      format.html { render :template => 'profiles/index' }
    end
  end

  def search
    @query = params[:q]
    @page = (params[:page] || 1).to_i
    @rows = (params[:rows] || 10).to_i
    results = Profile.find_by_solr(@query, :limit => @rows, :offset => @rows*(@page-1), :core => 'en')
    @hit_count = results.total
    @users = results.results.paginate(:page => @page, :per_page => @rows, :total_entries => @hit_count)
    respond_to do |format|
      format.html { render :template => 'profiles/index' }
    end
  end

  # show a given user's public profile information
  def show
    @profile = @user.profile
    @page_title = @user.display_name
    respond_to do |format|
      format.html { render :template => 'profiles/show' }
    end
  end

  # Renders an edit for for the current user's profile
  #
  # It is simple to override the edit template.  Simply create a template in app/views/profiles/edit.html.erb 
  # and add something similar to the following:
  #    <div id="edit_profile">
  #      <%= output_errors(t('muck.profiles.problem_editing_profile'), {:class => 'help-box'}, @profile) %>
  #      <% profile_form(@user) do |f| -%>
  #        <%# Add custom fields here.  ie %>
  #        <%= f.text_field :custom_thing %>
  #      <% end -%>
  #    </div>
  def edit
    @profile = @user.profile
    @page_title = t('muck.profiles.edit_profile_title', :name => @user.display_name)
    respond_to do |format|
      format.pjs do
        render_as_html do
          render :template => 'profiles/edit', :layout => false # fancybox request
        end
      end
      format.html { render :template => 'profiles/edit' }
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @page_title = t('muck.profiles.edit_profile_title', :name => @user.display_name)
    @user.update_attributes!(params[:user])
    respond_to do |format|
      flash[:notice] = t('muck.profiles.edit_success')
      format.html { redirect_back_or_default edit_user_profile_path(@user) }
    end
  rescue ActiveRecord::RecordInvalid => ex
    flash[:error] = t('muck.profiles.edit_failure')
    render :action => :edit
  end

  protected
    def setup_user
      if params[:user_id]
        @user = User.find(params[:user_id]) rescue nil
      end
      @user ||= User.find(params[:id])
    end
end
