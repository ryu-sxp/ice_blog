class AddColumnRelevantMediaToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :relevant_media, :boolean
  end
end
