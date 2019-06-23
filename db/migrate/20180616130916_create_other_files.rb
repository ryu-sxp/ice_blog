class CreateOtherFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :other_files do |t|
      t.string :name
      t.string :item

      t.timestamps
    end
  end
end
