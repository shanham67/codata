class Association < ActiveRecord::Base
  belongs_to :party
  belongs_to :associate, :class_name=>"Party", :foreign_key=>"associate_id"
  belongs_to :role
end
