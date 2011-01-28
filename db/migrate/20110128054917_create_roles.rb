class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.integer :correlative_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
