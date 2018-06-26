class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :theme
      t.string :password_digest
      t.boolean :admin, default: false
      t.string :activation_digest
      t.boolean :activated, default: false
      t.boolean :tweet_posts, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at
      t.string :avatar
      t.string :about
      t.string :forum_url
      t.string :blog_post_toot_visibility, default: "unlisted"

      t.string :meta_keywords
      t.string :meta_desc
      t.string :site_name, default: "My Blog"
      t.string :site_slogan, default: "Powered by IceBlog"

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
