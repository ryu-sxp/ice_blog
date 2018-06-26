class CreateSpamComments < ActiveRecord::Migration[5.1]
  def change
    create_table :spam_comments do |t|
      t.string :name
      t.string :email
      t.string :website
      t.text :content
      t.string :blog_spam_result
      t.string :blog_spam_reason
      t.string :blog_spam_blocker
      t.string :blog_spam_version
      t.string :ip
      t.string :useragent

      t.timestamps
    end
  end
end
