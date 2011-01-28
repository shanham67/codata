class CreatePartyRelationships < ActiveRecord::Migration
  def self.up
    create_table :party_relationships do |t|
      t.integer :first_party_id
      t.integer :second_party_id
      t.integer :party_relationship_type_id
      t.date :begin_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :party_relationships
  end
end
