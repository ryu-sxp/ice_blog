class AddColumnBlogSpamFlagToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :blog_spam_flag, :boolean
  end
end
