class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.string :description
      t.integer :callable_id
      t.string :callable_type
      t.string :dial_code

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
