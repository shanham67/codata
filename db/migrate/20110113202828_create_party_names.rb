class CreatePartyNames < ActiveRecord::Migration
  def self.up
    create_table :party_names do |t|
      t.references :party
      t.string :function
      t.string :surname
      t.string :rest_of_name
      t.string :prefix
      t.string :suffix
      t.date :first_used_date

      t.timestamps
    end
  end

  def self.down
    drop_table :party_names
  end
end
