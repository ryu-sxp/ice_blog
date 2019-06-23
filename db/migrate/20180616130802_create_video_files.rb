class CreateVideoFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :video_files do |t|
      t.string :name
      t.string :item

      t.timestamps
    end
  end
end
