class AddSourceToResults < ActiveRecord::Migration
  def change
    add_column :results, :source, :string
  end
end
