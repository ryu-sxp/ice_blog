class CreateIpBlacklists < ActiveRecord::Migration[5.1]
  def change
    create_table :ip_blacklists do |t|
      t.string :ip
      t.integer :duration

      t.timestamps
    end
  end
end
