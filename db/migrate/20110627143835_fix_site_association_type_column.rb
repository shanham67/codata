class FixSiteAssociationTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :site_associations, :type, :description
  end

  def self.down
    rename_column :site_associations, :description, :type
  end
end
