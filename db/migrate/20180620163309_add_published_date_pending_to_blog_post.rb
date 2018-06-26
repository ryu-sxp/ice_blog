class AddPublishedDatePendingToBlogPost < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :published_date_pending, :boolean, default: false
  end
end
