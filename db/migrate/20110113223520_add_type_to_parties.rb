class AddTypeToParties < ActiveRecord::Migration
  def self.up
    add_column :parties, :type, :string
  end

  def self.down
    remove_column :parties, :type
  end
end
