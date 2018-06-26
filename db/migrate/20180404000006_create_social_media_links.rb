class CreateSocialMediaLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :social_media_links do |t|
      t.string :name
      t.string :url
      t.string :text
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
