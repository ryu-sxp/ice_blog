class AddExpiresAtToIpBlacklist < ActiveRecord::Migration[5.1]
  def change
    add_column :ip_blacklists, :expires_at, :integer
  end
end
