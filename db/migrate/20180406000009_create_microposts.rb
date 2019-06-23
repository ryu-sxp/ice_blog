class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.string :image
      t.datetime :published_date
      t.integer :toot_id, limit: 8
      t.integer :comments_c
      t.boolean :published, default: true

      #if Rails.env == "development"
        t.string :image_dimensions
      #else
        # assume production
      #  t.json :image_dimensions
      #end

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
