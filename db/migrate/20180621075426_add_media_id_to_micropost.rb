class AddMediaIdToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :media_id, :integer
  end
end
