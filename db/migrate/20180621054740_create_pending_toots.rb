class CreatePendingToots < ActiveRecord::Migration[5.1]
  def change
    create_table :pending_toots do |t|
      t.string :message
      t.string :source_model
      t.integer :source_id
      t.integer :media_id
      t.boolean :requires_file

      t.timestamps
    end
  end
end
