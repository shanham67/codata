class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.date :begin_date
      t.date :end_date
      t.integer :active_party_id
      t.date :superceded_date

      t.timestamps
    end
  end

  def self.down
    drop_table :parties
  end
end
