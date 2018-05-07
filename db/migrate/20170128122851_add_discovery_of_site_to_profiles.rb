class AddDiscoveryOfSiteToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :discovery_of_site, :text
  end
end
