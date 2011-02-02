class CreateAssociations < ActiveRecord::Migration
  def self.up
    create_table :associations do |t|
      t.integer :party_id
      t.integer :associate_id
      t.integer :role_id
      t.date :begin_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :associations
  end
end
