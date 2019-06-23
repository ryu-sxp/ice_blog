class AddVisibilityToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :visibility, :string
  end
end
