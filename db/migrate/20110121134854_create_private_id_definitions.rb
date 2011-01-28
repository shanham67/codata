class CreatePrivateIdDefinitions < ActiveRecord::Migration
  def self.up
    create_table :private_id_definitions do |t|
      t.integer :party_id
      t.string :name
      t.string :abbreviation
      t.timestamps
    end
  end

  def self.down
    drop_table :private_id_definitions
  end
end
