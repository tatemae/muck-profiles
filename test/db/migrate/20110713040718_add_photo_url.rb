class AddPhotoUrl < ActiveRecord::Migration
  def self.up
    add_column :profiles, :photo_remote_url, :string
  end

  def self.down
    remove_column :profiles, :photo_remote_url
  end
end