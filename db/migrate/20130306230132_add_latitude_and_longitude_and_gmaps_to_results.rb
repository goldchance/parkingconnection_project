class AddLatitudeAndLongitudeAndGmapsToResults < ActiveRecord::Migration
  def change
    add_column :results, :latitude, :float
    add_column :results, :longitude, :float
    add_column :results, :gmaps, :boolean
  end
end
