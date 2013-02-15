class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.string :owner
      t.string :location
      t.string :address
      t.string :price
      t.string :desc
      t.timestamps
    end
  end

  def self.down
    drop_table :results
  end
end
