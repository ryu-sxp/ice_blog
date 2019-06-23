class CreateImageFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :image_files do |t|
      t.string :name
      t.string :item
      #if Rails.env == "development"
        t.string :image_dimensions
      #else
        # assume production
      #  t.json :image_dimensions
      #end

      t.timestamps
    end
  end
end
