class CreateStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :statistics do |t|
      t.integer :requests_c
      t.integer :visits_c
      t.integer :bot_requests_c

      t.timestamps
    end
  end
end
