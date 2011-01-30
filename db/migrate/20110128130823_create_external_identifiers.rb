class CreateExternalIdentifiers < ActiveRecord::Migration
  def self.up
    create_table :external_identifiers do |t|
      t.integer :party_id
      t.integer :private_id_definition_id
      t.string :identifier

      t.timestamps
    end
  end

  def self.down
    drop_table :external_identifiers
  end
end
