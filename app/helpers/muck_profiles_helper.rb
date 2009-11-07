module MuckProfilesHelper

  # Renders a profile edit form
  # content:  Optional content object to be edited.
  # options:  html options for form.  For example:
  #             :html => {:id => 'a form'}
  def profile_form(profile, options = {}, &block)
    options[:html] = {} if options[:html].nil?
    raw_block_to_partial('profiles/form', options.merge(:profile => profile), &block)
  end
  
end