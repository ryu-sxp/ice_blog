class AddColumnsDraftContentUpdateToBlogPost < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :draft, :text
    add_column :blog_posts, :content_update, :text
  end
end
