class AddFieldsToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :about, :text
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string

    # possible fields
    # website
    # city
    # state
    # country
    # zip
    # language
    # gender
    # age
    # birthday
    # relationship status
    # Occupation
    # Time Zone
    # phone
    
    # 
    # IM
    # Interests
    # Skills
    
  end

  def self.down
    remove_column :profiles, :about
    remove_column :profiles, :first_name
    remove_column :profiles, :last_name
  end
end
