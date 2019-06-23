class AddColumnNameToBlogPost < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :name, :string
  end
end
