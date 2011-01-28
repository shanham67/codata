class PartyRelationship < ActiveRecord::Base
  belongs_to :first_party, :class_name=>"Party", :foreign_key => "first_party_id"
  belongs_to :second_party, :class_name=>"Party", :foreign_key => "second_party_id"
  belongs_to :party_relationship_type, :class_name=>"PartyRelationshipType", :foreign_key => "party_relationship_type_id"
end
