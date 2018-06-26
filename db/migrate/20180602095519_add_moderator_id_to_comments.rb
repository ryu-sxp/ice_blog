class AddModeratorIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :moderator_id, :integer
  end
end
