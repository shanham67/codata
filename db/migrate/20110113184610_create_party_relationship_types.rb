class CreatePartyRelationshipTypes < ActiveRecord::Migration
  def self.up
    create_table :party_relationship_types do |t|
      t.string :description
      t.string :party1_role
      t.string :party2_role

      t.timestamps
    end
  end

  def self.down
    drop_table :party_relationship_types
  end
end
