class Role < ActiveRecord::Base
  belongs_to :correlative, :class_name=>"Role", :foreign_key=>"correlative_id"
  def self.create_relationship( r1_name, r2_name )
    r1 = Role.new( :name=> r1_name )
    r1.save
    r2 = Role.new( :name=> r2_name, :correlative_id => r1.id )
    r2.save
    r1.correlative_id = r2.id
    r1.save
  end

end
