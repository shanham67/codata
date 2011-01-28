class Relationship < ActiveRecord::Base
  belongs_to :party
  belongs_to :role
  belongs_to :counterpart, :class_name=>"Relationship", :foreign_key=>"counterpart_id"
end
