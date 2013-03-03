class AddHrefToResults < ActiveRecord::Migration
  def change
    add_column :results, :href, :string
  end
end
