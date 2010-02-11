module MuckProfilesHelper

  # Renders a profile edit form
  # content:  Optional content object to be edited.
  # options:  html options for form.  For example:
  #             :html => {:id => 'a form'}
  def profile_form(user, options = {}, &block)
    options[:html] = {} if options[:html].nil?
    raw_block_to_partial('profiles/form', options.merge(:user => user), &block)
  end
  
  # Outputs a link and text that guesses the user's location using their ip.
  def location_suggestion(field_id)
    geo = Geokit::Geocoders::MultiGeocoder.geocode(request.ip)
    location = readable_location(geo)
    return '' if location.blank?
    render :partial => 'profiles/location_suggestion', :locals => { :field_id => field_id, :location => location }
  end
  
  # Turns a geokit location object into a location string with city, state country
  def readable_location(location)
    return '' if location.city.blank? && location.state.blank? && location.province.blank? && location.country_code.blank?
    "#{location.city}, #{location.state || location.province} #{location.country_code}"
  end
  
end