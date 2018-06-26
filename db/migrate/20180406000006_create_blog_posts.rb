class CreateBlogPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :icon
      t.datetime :published_date
      t.text :preview
      t.string :toot
      t.text :content
      t.integer :toot_id, limit: 8
      t.integer :comments_c
      t.boolean :published, default: false

      #if Rails.env == "development"
        t.string :images
        t.string :image_dimensions
      #else
        # assume production
      #  t.json :images
      #  t.json :image_dimensions
      #end

      t.references :blog_category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
