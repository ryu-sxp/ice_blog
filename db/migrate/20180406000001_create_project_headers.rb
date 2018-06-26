class CreateProjectHeaders < ActiveRecord::Migration[5.1]
  def change
    create_table :project_headers do |t|
      t.string :name

      t.timestamps
    end
  end
end
