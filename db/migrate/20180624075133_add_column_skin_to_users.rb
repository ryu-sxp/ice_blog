class AddColumnSkinToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :skin, :string
  end
end
