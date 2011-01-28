class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :party_id
      t.integer :role_id
      t.integer :counterpart_id
      t.date :begin_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
