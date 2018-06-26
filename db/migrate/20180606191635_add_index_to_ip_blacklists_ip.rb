class AddIndexToIpBlacklistsIp < ActiveRecord::Migration[5.1]
  def change
    add_index :ip_blacklists, :ip, unique: true
  end
end
