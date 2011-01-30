class SiteAssociation < ActiveRecord::Base
  belongs_to :party
  belongs_to :site
end
