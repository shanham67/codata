class CreateSiteAssociations < ActiveRecord::Migration
  def self.up
    create_table :site_associations do |t|
      t.integer :party_id
      t.integer :site_id
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :site_associations
  end
end
