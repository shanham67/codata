class Site < ActiveRecord::Base
  has_many :phone_numbers, :as=>:callable
  has_many :addresses, :as=>:addressable
  has_many :site_associations
  has_many :parties, :through=>:site_associations
end
