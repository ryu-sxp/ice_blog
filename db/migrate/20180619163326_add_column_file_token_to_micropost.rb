class AddColumnFileTokenToMicropost < ActiveRecord::Migration[5.1]
  def change
    add_column :microposts, :filetoken, :string
  end
end
