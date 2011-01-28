class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.integer :emailable_id
      t.string :emailable_type
      t.string :url
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :email_addresses
  end
end
