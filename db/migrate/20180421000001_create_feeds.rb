class CreateFeeds < ActiveRecord::Migration[5.1]
  def change
    create_table :feeds do |t|
      t.string  :source_model
      t.datetime :published_date
      t.integer :source_id
      t.boolean :published

      t.timestamps
    end
  end
end
