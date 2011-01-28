class PrivateIdDefinition < ActiveRecord::Base
  attr_accessible :party_id, :name, :abbreviation
  belongs_to :party
end
