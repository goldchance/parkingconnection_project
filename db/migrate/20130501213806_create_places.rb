class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :href
      t.string :location
      t.string :address
      t.string :price
      t.string :urlimage
      t.string :desc
      t.integer :source_id
      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
