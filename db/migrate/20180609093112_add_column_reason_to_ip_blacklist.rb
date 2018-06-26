class AddColumnReasonToIpBlacklist < ActiveRecord::Migration[5.1]
  def change
    add_column :ip_blacklists, :reason, :string
  end
end
