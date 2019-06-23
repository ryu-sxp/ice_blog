class AddColumnsToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :sensitive, :boolean
    add_column :microposts, :spoiler_text, :string
  end
end
