class ExternalIdentifier < ActiveRecord::Base
   belongs_to :party
   belongs_to :private_id_definition
end
