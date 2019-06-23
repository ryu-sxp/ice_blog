class AddIpToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :ip, :string
  end
end
