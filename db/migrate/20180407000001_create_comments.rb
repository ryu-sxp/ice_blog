class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string  :name
      t.string  :trip
      t.string  :email
      t.string  :website
      t.string  :source_model
      t.integer :source_id

      t.timestamps
    end
  end
end
