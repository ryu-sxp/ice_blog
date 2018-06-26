class CreateStickyMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :sticky_messages do |t|
      t.text :content
      t.text :draft
      t.boolean :published
      t.boolean :important
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
