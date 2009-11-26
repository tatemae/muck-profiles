module MuckProfilesHelper

  # Renders a profile edit form
  # content:  Optional content object to be edited.
  # options:  html options for form.  For example:
  #             :html => {:id => 'a form'}
  def profile_form(profile, options = {}, &block)
    options[:html] = {} if options[:html].nil?
    raw_block_to_partial('profiles/form', options.merge(:profile => profile), &block)
  end
  
  def location_suggestion(field_id)
    location = session[:geo_location]
    render :partial => 'profiles/location_suggestion', :locals => { :field_id => field_id }
  end
  
  # Turns a geokit location object into a location string with city, state country
  def readable_location(location)
    "#{location.city}, #{location.state || location.province} #{location.country_code}"
  end
  
end