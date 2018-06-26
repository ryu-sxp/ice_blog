class AddColumnsDraftContentUpdateToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :draft, :text
    add_column :projects, :content_update, :text
  end
end
