class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :icon
      t.text :content
      t.boolean :published, default: false

      #if Rails.env == "development"
        t.string :images
        t.string :image_dimensions
      #else
        # assume production
      #  t.json :images
      #  t.json :image_dimensions
      #end

      t.references :project_header, foreign_key: true

      t.timestamps
    end
  end
end
