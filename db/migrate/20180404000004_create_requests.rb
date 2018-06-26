class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :referer
      t.string :useragent
      t.string :request
      t.boolean :new_visitor
      t.boolean :is_bot
      t.boolean :counter_flag

      t.timestamps
    end
    add_index :requests, [:new_visitor, :counter_flag, :is_bot]
  end
end
