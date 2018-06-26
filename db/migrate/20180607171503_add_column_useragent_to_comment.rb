class AddColumnUseragentToComment < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :useragent, :string
  end
end
