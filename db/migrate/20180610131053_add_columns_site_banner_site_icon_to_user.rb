class AddColumnsSiteBannerSiteIconToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :site_banner, :string
    add_column :users, :site_icon, :string
  end
end
