class AddRequestIdToResults < ActiveRecord::Migration
  def change
    add_column :results, :request_id, :integer
  end
end
