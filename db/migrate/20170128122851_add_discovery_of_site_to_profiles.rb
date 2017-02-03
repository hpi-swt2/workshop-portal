class AddDiscoveryOfSiteToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :discovery_of_site, :text
  end
end
