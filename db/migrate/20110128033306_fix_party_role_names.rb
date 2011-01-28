class FixPartyRoleNames < ActiveRecord::Migration
  def self.up
    rename_column :party_relationship_types, :party1_role, :first_party_role
    rename_column :party_relationship_types, :party2_role, :second_party_role
  end

  def self.down
    rename_column :party_relationship_types, :first_party_role, :party1_role
    rename_column :party_relationship_types, :second_party_role, :party2_role
  end
end
