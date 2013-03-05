class AddUrlimageToResults < ActiveRecord::Migration
  def change
    add_column :results, :urlimage, :string
  end
end
